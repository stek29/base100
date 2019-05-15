// Licensed under UNLICENSE
// See UNLICENSE provided with this file for details
// For more information, please refer to <http://unlicense.org/>

primitive Base100
  fun _first(): U8 => 0xf0
  fun _second(): U8 => 0x9f

  fun _shift(): U8 => 55
  fun _divisor(): U8 => 64

  fun _third(): U8 => 0x8f
  fun _fourth(): U8 => 0x80

  fun encode(data: Array[U8] val): Array[U8] iso^ =>
    recover iso
      let out = Array[U8](data.size() * 4)
      for (i, b) in data.pairs() do
        try
          let j = i * 4
          out.insert(j+0, _first())?
          out.insert(j+1, _second())?
          out.insert(j+2, ((b + _shift()) / _divisor()) + _third())?
          out.insert(j+3, ((b + _shift()) % _divisor()) + _fourth())?
        end
      end
      out
    end

  fun decode(data: Array[U8] val): Array[U8] iso^ ? =>
    if (data.size() % 4) != 0 then error end
    recover iso
      let out = Array[U8](data.size() / 4)
      var i = USize(0)
      while i < data.size() do
        let tmp = (data(i + 2)? - _third()) * _divisor()
        let ch = ((data(i + 3)? - _fourth()) + tmp) - _shift()
        out.insert(i / 4, ch)?
        i = i + 4
      end
      out
    end
