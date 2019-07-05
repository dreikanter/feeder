import scale from 'lib/utils/scale'

test('can scale up', () => {
  expect(scale(50, 0, 100, 0, 1000)).toBeCloseTo(500)
})

test('can scale down', () => {
  expect(scale(500, 0, 1000, 0, 100)).toBeCloseTo(50)
})

test('can scale 1:1', () => {
  expect(scale(5, 0, 10, 0, 10)).toBeCloseTo(5)
})

test('can handle zero length', () => {
  expect(scale(0, 0, 0, 0, 0)).toBeCloseTo(0)
})

test('can scale negative', () => {
  expect(scale(-1, -10, 10, -100, 100)).toBeCloseTo(-10)
})
