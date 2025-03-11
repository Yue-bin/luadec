# luadec

一个装饰器的lua实现，让你可以在lua中较为优雅地使用装饰器。

**建议使用[lua-users wiki: 装饰器和文档字符串 - Lua 编程语言](https://lua-users.lua.ac.cn/wiki/DecoratorsAndDocstrings)，他的实现比我优雅太多**

~~如果早点看到就不会有这个项目了我的搜索力真是可悲啊~~

## 用法

模块中可访问的一共有三个接口

- `add_decorator(name, decorator)`

  用于向当前 `luadec`实例中添加装饰器，注意添加的装饰器**必须**含有至少一个参数且第一个参数是可调用的

  请在使用 `at(name)`进行装饰之前添加相应的装饰器
- `start_listen(table_to_listen)`

  用于监听指定表中可调用对象的创建行为，在 `at(name)`之前使用
- `at(name)`

  用于装饰表中下一个创建的可调用对象

*此处假设用户使用如下代码导入本模块*

```lua
  local luadec = require("luadec")
```

示例如下

```lua
-- 向当前实例中添加装饰器
luadec.add_decorator("dec_1", function(func)
    print("dec_1")
    func()
end)

-- 开始对全局表的监听
luadec.start_listen(_G)
-- 或者对模块表进行监听
-- lucdec.start_listen(_M)

-- 使用装饰器
luadec.at("dec_1")
function test()
    print("test")
end


-- 使用装饰过后的函数
test()
-- 输出：
-- 	dec_1
--	test
```

同一个 `luadec`实例可以在不同的范围使用和传递，只需在传递后重新使用 `start_listen(table_to_listen)`指定要监听的新表。但是请保证在代码执行顺序中不会出现在监听一个表的时候在其它地方使用 `at`，这会导致某些非预期的行为，但是由于装饰是实时的，在 `at`后的第一个可调用对象的创建时立即装饰，所以在保证执行顺序的情况下它仍能被用于不同的范围。

## 鸣谢

灵感来自[在Lua中使用装饰器 - Luyu Huang&#39;s Blog](https://luyuhuang.tech/2019/09/15/lua-decorator.html)
