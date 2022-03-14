// https://github.com/HashLips/generative-art-node repo used
const { buildSetup, createFiles, createMetaData } = require("./src/main.js");
const { defaultEdition } = require("./src/config.js");

(() => {
  buildSetup();
  createFiles(defaultEdition);
  createMetaData();
})();