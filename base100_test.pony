// Licensed under UNLICENSE
// See UNLICENSE provided with this file for details
// For more information, please refer to <http://unlicense.org/>

// Build: ponyc . -b base100_pony
// Execute: ./base100_pony

use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_Encode)
    test(_Decode)
    test(_Flow)

class iso _Encode is UnitTest
  fun name(): String => "encode"
  fun apply(h: TestHelper) =>
    let input: Array[U8] val = ['h'; 'i']
    let expected: Array[U8] val =
      [0xf0; 0x9f; 0x91; 0x9f; 0xf0; 0x9f; 0x91; 0xa0]
    let expected_str = "👟👠"
    let output = recover val Base100.encode(input) end
    h.assert_array_eq[U8](output, expected)
    let output_str = String.from_array(output)
    h.assert_eq[String](output_str, expected_str)

class iso _Decode is UnitTest
  fun name(): String => "decode"
  fun apply(h: TestHelper) =>
    let input_str = "👟👜👣👣👦"
    let expected_str = "hello"
    let input = input_str.array()
    let expected = expected_str.array()
    try
      let output = recover val Base100.decode(input)? end
      h.assert_array_eq[U8](output, expected)
      let output_str = String.from_array(output)
      h.assert_eq[String](output_str, expected_str)
    else
      h.fail()
    end

class iso _Flow is UnitTest
  fun name(): String => "decode(encode(x)) = x"
  fun apply(h: TestHelper) =>
    let input_str = "the quick brown fox 😂😂👌👌👌 over the lazy dog привет"
    let input = input_str.array()
    try
      let output: Array[U8] val = Base100.decode(Base100.encode(input))?
      h.assert_array_eq[U8](output, input)
      let output_str = String.from_array(output)
      h.assert_eq[String](output_str, input_str)
    else
      h.fail()
    end
