export default (x, inMin, inMax, outMin, outMax) => (
  (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
)
