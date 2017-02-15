require("babel-polyfill");

var webpack = require('webpack')
var ExtractTextPlugin = require("extract-text-webpack-plugin");
module.exports = {
    entry: './src/index.js',

    output: {
        path: './dist',
        filename: 'index.js',
    },
debug: true,
    resolve: {
        modulesDirectories: ['node_modules'],
        extensions: ['', '.js', '.elm', '.css']
    },

    module: {
        loaders: [
            {
                test: /\.html$/,
                loader: 'file?name=[name].[ext]'
            },
            {
                test: /\.css$/,
                loader: ExtractTextPlugin.extract("style-loader", "css-loader!postcss-loader")
            },
            {
                test: /\.less$/,
                loader: ExtractTextPlugin.extract("style", "css-loader!postcss-loader!less-loader")
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack?debug=true'
            },
            {
                test: /\.woff($|\?)|\.woff2($|\?)|\.ttf($|\?)|\.eot($|\?)|\.svg($|\?)/,
                loader: 'url-loader'
            }
        ],

        noParse: /\.elm$/
    },

    plugins: [
        new webpack.ProvidePlugin({
            jQuery: 'jquery',
            $: 'jquery',
            jquery: 'jquery'
        }),
        new ExtractTextPlugin("styles.css"),
    ],

    devServer: {
        inline: true,
        stats: 'errors-only'
    }
};


