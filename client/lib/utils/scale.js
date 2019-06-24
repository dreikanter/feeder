function scale (x, inMin, inMax, outMin, outMax) {
  if (inMin === inMax) {
    return (outMax + outMin) / 2
  }

  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
}

export default scale
