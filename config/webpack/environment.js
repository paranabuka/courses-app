const { environment } = require("@rails/webpacker");
const webpack = require("webpack");

environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    Popper: ["@popperjs/core", "default"],
  })
);

environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
  })
);

module.exports = environment;
