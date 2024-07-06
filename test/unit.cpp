#include "../src/math.h"
#include <gtest/gtest.h>

TEST(MathAdd, PositiveNum) { EXPECT_EQ(2, math::add(1, 1)); }

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
