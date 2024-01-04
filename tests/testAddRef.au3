#include "../au3pm/au3unit/Unit/assert.au3"
#include "../Vector.au3"

#cs
# Test that AddRef is called on IUnknown
#ce

Global $a = Vector()
Global $b = Vector()

GLobal $tObject = DllStructCreate($__g_Vector_tagObject, Ptr($b) - 8)

assertEquals(1, $tObject.RefCount)

$a.push_back($b)

assertEquals(2, $tObject.RefCount)

$c = $a.at(0)

assertEquals(2, $tObject.RefCount)

$c = 0

assertEquals(2, $tObject.RefCount)

$a = 0

assertEquals(1, $tObject.RefCount)

$b = 0
