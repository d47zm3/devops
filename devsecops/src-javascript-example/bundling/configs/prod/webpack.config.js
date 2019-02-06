const webpack = require('webpack');
const path = require('path');

const projectPath = path.join(__dirname, './../../../');
const srcPath = './src/';
const distPath = './dist/';
const mode = 'production';

const definePlugin = new webpack.DefinePlugin({
  'process.env.NODE_ENV': JSON.stringify(mode)
});

const babelSettings = {
  test: /\.js$/,
  exclude: /(node_modules|bower_components)/,
  use: {
    loader: 'babel-loader',
    options: {
      extends: path.join(__dirname, '.babelrc')
    }
  }
};

const config = {
  context: projectPath,
  entry: () => {
    return {
      'app': path.join(projectPath, srcPath) + 'js/index.js',
    }
  },
  output: {
      path: path.join(projectPath, distPath + 'js'),
      filename: '[name].js'
    },
  module: {
    rules: [
      babelSettings,
    ]
  },
  resolve: {
    modules: ["node_modules"]
  },
  plugins: [
    definePlugin
  ],
  mode: mode,
};

module.exports = config;
