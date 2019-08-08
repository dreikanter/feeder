function seconds (amount) {
  if (!amount) {
    return undefined
  }

  const value = amount.toFixed(2)

  return `${value} s`
}

export default seconds
