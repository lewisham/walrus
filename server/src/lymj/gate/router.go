package gate

import (
	"lymj/game"
	"lymj/msg"
)

func init() {
	msg.Processor.SetRouter(&msg.Hello{}, game.ChanRPC)
	msg.Processor.SetRouter(&msg.Msg2Login{}, game.ChanRPC)
}
