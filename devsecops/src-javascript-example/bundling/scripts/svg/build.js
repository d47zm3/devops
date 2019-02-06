#!/usr/bin/env node

const SvgSprite = require('svg-sprite');
const helpers = require('../config/helpers');
const path = require('path');

const projectRootPath = path.resolve(__dirname, '../../../');
const svgRootPath = path.resolve(projectRootPath, 'src/images/icons');
const svgDistPath = path.resolve(projectRootPath, 'dist/images');
const distName = 'icons.svg';

const spriter = new SvgSprite({
  dest: 'out',
  mode: {
    symbol: {
      inline: true,
    }
  }
});

const getSVG = (path) => helpers.asyncReadFile(path)
  .then((data) => {
    return {path, data}
  });

const getSVGs = (paths) => Promise.all(paths.map(getSVG));

const addSVGs = (svgsData) => Promise.all(svgsData.map(addSVG));

const addSVG = (({path, data}) => Promise.resolve(spriter.add(path, null, data)));

const compile = () => new Promise((resolve, reject) => {
  spriter.compile((error, result) => {
    if (error) reject(error);
    try {
      resolve(result.symbol.sprite.contents);
    } catch (e) {
      reject(e);
    }
  });
});

const save = (data) => helpers.asyncWriteFile({path:`${svgDistPath}/${distName}`, data});

helpers.generatePath(svgDistPath)
  .then(() => helpers.asyncGlob(`${svgRootPath}/*.svg`))
  .then(getSVGs)
  .then(addSVGs)
  .then(compile)
  .then(save)
  .catch(console.log);
