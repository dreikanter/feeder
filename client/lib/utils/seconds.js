function seconds (amount) {
  const value = amount.toPrecision(2)

  return `${value} s`
}

export default seconds
