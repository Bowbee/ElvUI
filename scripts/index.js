// make modifications to Elvui Core via script.
const fs = require('fs');
const path = require('path');

const elvuiPath = path.join(__dirname, '..', 'ElvUI');

const chatLuaFile = path.join(elvuiPath, 'Core', 'Modules', 'Chat', 'Chat.lua');
const chatLua = fs.readFileSync(chatLuaFile, 'utf8');

// copy media to Core/Media/ChatLogos
const mediaPath = path.join(elvuiPath, 'Core', 'Media', 'ChatLogos');
const bowbiLogo = path.join(__dirname, 'media', 'Beer.tga');
const bowbiLogoDest = path.join(mediaPath, 'Beer.tga');
fs.copyFileSync(bowbiLogo, bowbiLogoDest);

const fileAsArray = chatLua.split('\n');

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

const colorLine = "local ElvColors = function(t)";
const colorLineIndex = getIndexOfLine(colorLine);
const bowbColourLine = "		local BowbColours = function(t) return specialText(t, 0.99,0.33,0.0, 0.99,0.66,0.10) end";
addLineOfText(bowbColourLine, colorLineIndex + 1, 0);

const functionLine = "itsThradex = function()";
const functionLineIndex = getIndexOfLine(functionLine);
const bowbFunctionLine = "		itsBowb = function() return Beer, BowbColours end";
addLineOfText(bowbFunctionLine, functionLineIndex + 1, 0);

const nameLine = "z['Elv-Spirestone']";
const nameLineIndex = getIndexOfLine(nameLine);
const bowbiNameLine = "    z['Bowbi-Frostmourne'] = itsBowb";
addLineOfText(bowbiNameLine, nameLineIndex + 1, 0);

writeFile();
