getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min)) + min

curry = (f) ->
  parameters = Array.prototype.slice.call(arguments, 1)
  -> f.apply this, parameters.concat(Array.prototype.slice.call(arguments, 0))

generateRandArray = ({ size, min, max }) ->
  res = []
  res.push(getRandomInt(min, max)) for i in [0...size]
  res

module.exports = { curry, generateRandArray }
