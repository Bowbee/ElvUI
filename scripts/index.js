// make modifications to Elvui Core via script.
const fs = require('fs');
const path = require('path');
const elvuiPath = path.join(__dirname, '..', 'ElvUI');

const getIndexOfLine = (text) => {
  // find the index of the line we want to add. partial match.
  const index = fileAsArray.findIndex(line => line.includes(text));
  return index;
};

const addLineOfText = (text, index, replace) => {
  fileAsArray.splice(index, replace, text);
  console.log(`Added line ${text} at index ${index}`);
};

const writeFile = () => {
  fs.writeFileSync(chatLuaFile, fileAsArray.join('\n'), 'utf8');
};

// Copy media to Core/Media/ChatLogos
const mediaPath = path.join(elvuiPath, 'Core', 'Media', 'ChatLogos');
const bowbiLogo = path.join(__dirname, 'media', 'Beer.tga');
const bowbiLogoDest = path.join(mediaPath, 'Beer.tga');
fs.copyFileSync(bowbiLogo, bowbiLogoDest);
const veilLogo = path.join(__dirname, 'media', 'TyroneBiggums.tga');
const veilLogoDest = path.join(mediaPath, 'TyroneBiggums.tga');
fs.copyFileSync(veilLogo, veilLogoDest);

// Read the file into an array.
const chatLuaFile = path.join(elvuiPath, 'Core', 'Modules', 'Chat', 'Chat.lua');
const chatLua = fs.readFileSync(chatLuaFile, 'utf8');
const fileAsArray = chatLua.split('\n');

// Colour configs.
const colorLine = "local ElvColors = function(t)";
const colorLineIndex = getIndexOfLine(colorLine);
const colours = [
  "		local VeilOrange = function(t) return specialText(t, 0.99,0.33,0.0, 0.99,0.66,0.10) end",
  "		local VeilBlue = function(t) return specialText(t, 0.0,0.33,0.99, 0.10,0.66,0.99) end",
  "    local VeilPink = function(t) return specialText(t, 0.80,0.0,0.99, 0.60,0.0,0.99) end",
];
colours.forEach((func, index) => {
  addLineOfText(func, colorLineIndex + index + 1, 0);
});

// Format lines.
const formatLine = "itsThradex = function()";
const formatLineIndex = getIndexOfLine(formatLine);
const addFormatLines = [
  "		veilOrange = function() return Beer, VeilOrange end",
  "		veilBlue = function() return TyroneBiggums, VeilBlue end",
  "   veilPink = function() return Hibiscus, VeilPink end",
];
addFormatLines.forEach((func, index) => {
  addLineOfText(func, formatLineIndex + index + 1, 0);
});

// Characters.
const nameLine = "z['Elv-Spirestone']";
const nameLineIndex = getIndexOfLine(nameLine);
const characters = {
  "Bowbi-Frostmourne": "veilOrange",
  "Demobalth-Frostmourne": "veilBlue",
  "Mogybear-Frostmourne": "veilBlue",
  "Meeooww-Frostmourne": "veilPink",
  "TorxyPriest-Frostmourne": "itsThradex",
}
Object.keys(characters).forEach((key, index) => {
  const line = `    z['${key}'] = ${characters[key]}`;
  addLineOfText(line, nameLineIndex + index + 1, 0);
});


writeFile();
