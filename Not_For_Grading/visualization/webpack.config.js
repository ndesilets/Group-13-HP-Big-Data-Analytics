const webpack = require('webpack');
const path = require('path');

// Plugins 
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  //devtool: 'cheap-module-eval-source-map',
  
  // Input files 
  entry: {
    app: './src/main.ts',
    vendor: './src/vendor.ts',
    polyfills: './src/polyfills.ts'
  },

  // Output files 
  /*output: {
    path: root('dist'),
    filename: '[name].js',
    chunkFilename: '[id].[hash].chunk.js'
  },*/

  // Resolving extensionless filenames in import 
  // look for node_modules in ../
  resolve: {
    extensions: ['.ts', '.js', '.scss', '.html']
  },

  module: {
    // Loader rules 
    rules: [
      {
        test: /\.html$/,
        loader: 'html-loader'
      },
      {
        test: /\.ts$/,
        loaders: [
          {
            loader: 'awesome-typescript-loader',
            options: { 
              configFileName: root('tsconfig.json') 
            }
          },
          'angular2-template-loader'
        ]
      },
      {
        test: /\.scss$/,
        use: [
          {
            loader: 'style-loader' // creates style nodes from js strings 
          },
          {
            loader: 'css-loader', // translates css to commonjs
            options: {
                sourceMap: true
            }
          },
          {
            loader: 'sass-loader', // compiles sass to css
            options: {
                sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.css$/,
        exclude: root('src', 'app'),
        loader: ExtractTextPlugin.extract({ fallbackLoader: 'style-loader', loader: 'css-loader?sourceMap' })
      },
      {
        test: /\.css$/,
        include: root('src', 'app'),
        loader: 'raw-loader'
      },
      {
        test: /\.(png|jpe?g|gif|svg|woff|woff2|ttf|eot|ico)$/,
        loader: 'file-loader?name=assets/[name].[hash].[ext]'
      },
    ],
  },

  // Plugins
  plugins: [
    new webpack.optimize.CommonsChunkPlugin({
      name: ['app', 'vendor', 'polyfills']
    }),

    new HtmlWebpackPlugin({
      template: 'src/index.html'
    }),

    /*new ExtractTextPlugin({
      filename: '[name].[contenthash].css'
    })*/
  ]
}

// Misc 
function root(args){
  args = Array.prototype.slice.call(arguments, 0);
  return path.join.apply(path, [__dirname].concat(args));
}