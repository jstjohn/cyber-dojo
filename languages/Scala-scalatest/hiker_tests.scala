
import org.scalatest.FunSuite
import Hiker._

class HikerSuite extends FunSuite {
  
  test("the answer to life the universe and everything") {
    assert(answer() == 42)
  }
  test("Another example test") {
    assert(answer() != 54)
  }

}
