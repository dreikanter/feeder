import mapActivityValues from 'main/utils/mapActivityValues'

const sampleActivity = {
  '2018-09-18': 14,
  '2018-09-19': 18,
  '2018-09-20': 24
}

const expected = [
  { date: '2018-09-18', count: 14 },
  { date: '2018-09-19', count: 18 },
  { date: '2018-09-20', count: 24 }
]

test('maps the values', () => {
  expect(mapActivityValues(sampleActivity)).toEqual(expected)
})
