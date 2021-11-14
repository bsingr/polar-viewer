const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
    Chart: ['chart.js', 'default'],
    Leaflet: ['leaflet.js', 'default']
}))

module.exports = environment

