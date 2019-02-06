#!/usr/bin/env node

// Dependencies
const path = require('path');
const glob = require('glob');
const process = require('process');
const handlebars = require('handlebars');
const helpers = require('../config/helpers');

// Paths
const projectRootPath = path.resolve(__dirname, '../../../');
const handlebarsRootPath = path.resolve(projectRootPath, 'src/docs');
const handlebarsPartialsPath = path.resolve(handlebarsRootPath, 'partials');
const distPath = path.resolve(projectRootPath, 'dist');

const handlebarsExtension = 'hbs';

const getPartialNameFromPath = (path) =>
  path
    .replace(`${handlebarsPartialsPath}/`, '')
    .replace(`.${handlebarsExtension}`, '');

const getIndexNameFromPath = (path) =>
  path
    .replace(`${handlebarsRootPath}/`, '')
    .replace(`.${handlebarsExtension}`, '');

const getIndexDistName = (inputPath) =>
  `${distPath}/${getIndexNameFromPath(inputPath)}.html`;

const getPartials = () => new Promise((resolve, reject) => {
  glob(`${handlebarsPartialsPath}/**/*.${handlebarsExtension}`, (err, files) => {
    if (err) reject(err);
    resolve(files);
  });
});

const getPartialsContent = (paths) => Promise.all(paths.map(getPartialContent));
const getPartialContent = (path) =>
  helpers.asyncReadFile(path)
    .then((data) => {
      return {path, data}
    });

const registerPartials = (partialsData) => Promise.all(partialsData.map(registerPartial));
const registerPartial = (partialData) => new Promise((resolve, reject) => {
  const partial = {
    name: getPartialNameFromPath(partialData.path),
    data: partialData.data
  };

  try {
    resolve(handlebars.registerPartial(partial.name, partial.data));
  } catch (err) {
    reject(err);
  }
});

const getIndexes = () => new Promise((resolve, reject) => {
  glob(`${handlebarsRootPath}/*.${handlebarsExtension}`, (err, files) => {
    if (err) reject(err);
    resolve(files);
  });
});

const compileIndex = (path) =>
  helpers.asyncReadFile(path)
    .then((indexContent) => new Promise((resolve, reject) => {
      try {
        const template = handlebars.compile(indexContent);
        resolve({
          path,
          data: template(),
        })

      } catch (err) {
        reject(err)
      }
    }));

const compileIndexes = (paths) => Promise.all(paths.map(compileIndex));
const saveAll = (indexesData) => Promise.all(indexesData.map(saveIndex));
const saveIndex = (indexData) => helpers.asyncWriteFile({path: getIndexDistName(indexData.path), data: indexData.data});

const logger = (message) => {
  process.stdout.write(`${message}\n`);
};

const errorHandler = (error) => {
  logger(error.message);
  logger(error.stack);
};

helpers.generatePath(distPath)
  .then(getPartials)
  .then(getPartialsContent)
  .then(registerPartials)
  .then(() => logger('Handlebars partials registered'))
  .then(getIndexes)
  .then(compileIndexes)
  .then(saveAll)
  .then(() => logger('Handlebars transformed into html'))
  .catch(errorHandler);
