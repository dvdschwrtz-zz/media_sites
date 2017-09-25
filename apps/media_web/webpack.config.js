const path = require('path')

const ClosureCompiler = require('google-closure-compiler-js').webpack
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

const ExtractMain = new ExtractTextPlugin('css/[name].css');
const ExtractInline = new ExtractTextPlugin('css/[name]-inline.css');
const ExtractAmp = new ExtractTextPlugin('css/[name]-amp.css');

const sites = process.env.MEDIA_ENV.split(',');
const regexSites = sites.reduce((acc, cur) => `${acc}|${cur}`);

module.exports = function getWebpackConfig (env) {
  return {
    context: path.resolve('web/static'),
    entry: getEntry(sites),
    output: {
      path: path.resolve('priv/static'),
      filename: 'js/[name].min.js'
    },
    module: {
      rules: getWebpackRules(env)
    },
    resolve: {
      modules: [
        'node_modules'
      ]
    },
    plugins: getWebpackPlugins(env),
  }
}

function getEntry (sites) {
  const entry = sites.map(site => {
    return {[site]: [
      './js/app.js',
      `./scss/${site}.scss`,
      `./scss/${site}-inline.scss`,
      `./scss/${site}-amp.scss`
    ]}
  });
  return entry.reduce((acc, site) => Object.assign({}, acc, site), {});
}

function getWebpackRules (env) {
  let rules = [
    {
      test: new RegExp(`(${regexSites})\.scss$`),
      loaders: ExtractMain.extract(['css-loader', 'sass-loader'])
    },
    {
      test: new RegExp(`(${regexSites})-inline\.scss$`),
      loaders: ExtractInline.extract(['css-loader', 'sass-loader'])
    },
    {
      test: new RegExp(`(${regexSites})-amp\.scss$`),
      loaders: ExtractAmp.extract(['css-loader', 'sass-loader'])
    },
    {
      test: /\.(jpe?g|png|gif|svg)$/i,
      loader: "file-loader?name=images/[name].[ext]"
    }
  ]

  return rules
}

function getWebpackPlugins (env) {
  let plugins = [
    new CopyWebpackPlugin([{from: './assets'}]),
    ExtractMain,
    ExtractInline,
    ExtractAmp
  ]

  if (env.prod) {
    plugins = plugins.concat([
      new ClosureCompiler({
        options: {
          languageIn: 'ECMASCRIPT6',
          languageOut: 'ECMASCRIPT5',
          compilationLevel: 'SIMPLE',
          createSourceMap: true
        }
      })
    ])
  }

  return plugins
}
