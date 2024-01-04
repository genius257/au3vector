#include "../au3pm/au3unit/Unit/assert.au3"
#include "../Vector.au3"

$vector = Vector()

assertEquals(0X7FFFFFFF, $vector.max_size)
