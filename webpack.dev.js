const merge = require('webpack-merge');
const common = require('./webpack.common');

module.exports = merge(common, {
  devtool: 'inline-source-map',
  devServer: {
    inline: true,
    stats: { colors: true }
  },
  watch: true
});
