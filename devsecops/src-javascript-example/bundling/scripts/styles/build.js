#!/usr/bin/env node

const path = require('path');
const process = require('process');
const sass = require('node-sass');
const chalk = require('chalk');
const postcss = require('postcss');
const autoprefixer = require('autoprefixer');
const cssnano = require('cssnano');

const helpers = require('../config/helpers');

// Configurations
const config = require('./../../configs/styleBuild');
const readyPrefixer = autoprefixer(require('./../../configs/autoprefixer'));
const readyCssnano = cssnano(require('./../../configs/cssnano'));

// Paths
const projectRootPath = path.resolve(__dirname, '../../../');
const includePath = path.resolve(projectRootPath, 'src/scss/');
const distPath = path.resolve(projectRootPath, 'dist/');
const outputPath = path.resolve(distPath, 'css/');

const producitonArgument = '-p';
const singleThemeArgument = '-t:';

// Arguments
const args = process.argv;
const isProduction = args.findIndex((arg) => arg.toLowerCase().indexOf(producitonArgument) > -1) > -1;
const singleThemeIndex = args.findIndex((arg) => arg.toLowerCase().indexOf(singleThemeArgument) > -1);

if(singleThemeIndex > -1) {
  const singleThemeArgsName = args[singleThemeIndex].replace(singleThemeArgument, '');
  const singleThemeConfigIndex = config.themes.findIndex((theme) => theme.name === singleThemeArgsName);

  if(singleThemeConfigIndex < 0) {
    throw new Error(`No '${singleThemeArgsName}' theme found in config file.`);
  }

  process.stdout.write(`Building only "${chalk.green(singleThemeArgsName)}" theme\r\n`);

  config.themes = [config.themes[singleThemeConfigIndex]];
}


// Get output name for single theme
const getDistCssName = (theme) => `${theme}.css`;

const parseConfig = (config) => {
  const themes = config.themes;
  const parsedConfig = {
    themes,
    inputs: [],
  };

  // Populate inputs
  themes.forEach((theme) => {
    const isDefined = parsedConfig.inputs.findIndex((input) => input.template === theme.input) > -1;
    if (!isDefined) {
      parsedConfig.inputs.push({
        name: theme.input,
        data: ''
      });
    }
  });

  return Promise
    .all(parsedConfig.inputs.map((input) => getInput(input)))
    .then((inputs) => {
      parsedConfig.inputs = inputs;
      return parsedConfig;
    });
};

const getInput = (input) =>
  helpers.asyncReadFile(path.resolve(projectRootPath, `src/scss/${input.name}.scss`))
    .then((data) => {
      return {
        name: input.name,
        data,
      }
    });

// Transform content for all themes by adding theme name variable
const transformAll = (extendedConfig) => {
  return extendedConfig.themes.map((theme) => transformSingle(theme, extendedConfig.inputs));
};

// Transform single theme by adding correct theme name variable
const transformSingle = (theme, inputs) => {
  const addition = `$currentTheme: ${theme.template};`;
  const inputObject = inputs.find((input) => input.name === theme.input);
  const themeContent = [addition, inputObject.data].join('\n');

  return Promise.resolve({
    data: themeContent,
    theme
  });
};

// Compile scss to css for all themes
const compileAll = (themesContent) => {
  return themesContent.map((themeContent) => compileSingle(themeContent));
};

// Compile scss to css for single theme
const compileSingle = ({theme, data}) => new Promise((resolve, reject) => {
  sass.render({
    data: data,
    outputStyle: isProduction ? 'compressed' : 'expanded',
    includePaths: [includePath],
    sourceMap: !isProduction,
    sourceMapEmbed: !isProduction,
    sourceComments: !isProduction,
    sourceMapContents: !isProduction,
  }, (err, result) => {
    if (err) {
      reject(err.formatted);
    } else {
      process.stdout.write(`Compiled theme: ${chalk.green(theme.name)} in ${chalk.blue(result.stats.duration)}ms\r\n`);
      resolve({
        theme,
        data: result
      });
    }
  });
});

// Postprocess all themes
const postcssAll = (compiledThemes) => {
  return compiledThemes.map((compiledTheme) => postcssSingle(compiledTheme));
};

// Postprocess single theme by autoprefixer and minify
const postcssSingle = ({theme, data}) => new Promise((resolve, reject) => {
  const cssContent = data.css.toString();
  const mapContent = JSON.stringify(data.map);
  const processors = [
    readyPrefixer,
  ];

  if (isProduction) {
    processors.push(readyCssnano)
  }

  const mapSettings = isProduction ?
    undefined :
    {inline: true, prev: mapContent};

  postcss(processors)
    .process(cssContent, {
      from: undefined,
      map: mapSettings
    })
    .then((result) => {
      result
        .warnings()
        .forEach((warn) => {
          console.warn(warn.toString());
        });

      resolve({
        theme,
        data: result.css
      });
    })
    .catch((e) => {
      reject(e);
    });
});

// Save all themes
const saveAll = (styles) => {
  return styles.map((style) => saveSingle(style));
};

// Save single theme
const saveSingle = ({theme, data}) => {
  const filename = path.resolve(outputPath, getDistCssName(theme.output));

  return helpers.asyncWriteFile({
    path: filename,
    data
  });
};


// Run process
helpers.generatePath(outputPath)
  .then(() => parseConfig(config))
  .then((extendedConfig) => Promise.all(transformAll(extendedConfig)))
  .then((themesContent) => Promise.all(compileAll(themesContent)))
  .then((compiledThemes) => Promise.all(postcssAll(compiledThemes)))
  .then((styles) => Promise.all(saveAll(styles)))
  .catch((e) => console.error(e));
