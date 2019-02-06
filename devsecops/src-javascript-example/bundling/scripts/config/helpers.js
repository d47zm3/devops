const chalk = require('chalk');
const fs = require('fs');
const glob = require('glob');
const shell = require('shelljs');

const asyncPathExist = (path) => new Promise((resolve) => {
  fs.access(path, fs.constants.F_OK, (err) => {
    err ? resolve(false) : resolve(true);
  });
});

const asyncReadFile = (filePath) => new Promise((resolve, reject) => {
  fs.readFile(filePath, {encoding: 'utf-8'},
    (err, data) => {
      (err) ?
        reject(err) :
        resolve(data);
    });
});

const asyncWriteFile = (fileData) => new Promise((resolve, reject) => {
  fs.writeFile(fileData.path, fileData.data, {encoding: 'utf8'}, (err) => {
    if (err) {
      reject(err);
    } else {
      process.stdout.write(`Saved ${chalk.green(fileData.path)}\n`);
      resolve(true);
    }
  });
});

const asyncCopyFile = (source, target) => new Promise((resolve, reject) =>  {
  fs.copyFile(source, target, (err) => {
    if (err) reject(err);
    resolve(true);
  });
});


const asyncGlob = (pattern) => new Promise((resolve, reject) => {
  glob(pattern, (err, files) => {
    if (err) reject(err);
    resolve(files);
  });
});

const generatePath = (path) => new Promise((resolve, reject) => {
  try {
    resolve(shell.mkdir('-p', path));
  } catch(e) {
    reject(e);
  }
});

module.exports = {
  asyncPathExist,
  asyncReadFile,
  asyncWriteFile,
  asyncGlob,
  generatePath,
  asyncCopyFile
};
