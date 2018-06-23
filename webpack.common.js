const path = require('path');

module.exports = {
  entry: {
    app: [
      './src/js/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/resources/public/js'),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/
  }
};
