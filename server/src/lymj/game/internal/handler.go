package internal

import (
	"lymj/msg"
	"reflect"

	"github.com/name5566/leaf/gate"
	"github.com/name5566/leaf/log"
)

func init() {
	handler(&msg.Hello{}, handeHello)
	handler(&msg.Msg2Login{}, handleLogin)
}

func handler(m interface{}, h interface{}) {
	skeleton.RegisterChanRPC(reflect.TypeOf(m), h)
}

func handeHello(args []interface{}) {
	m := args[0].(*msg.Hello)
	a := args[1].(gate.Agent)

	log.Debug("++++++++++++++++++hello %v", m.Name)

	// 给发送者回应一个 Hello 消息
	a.WriteMsg(&msg.Hello{
		Name: "client",
	})

}

func handleLogin(args []interface{}) {
	m := args[0].(*msg.Msg2Login)
	a := args[1].(gate.Agent)

	resp := new(msg.RespLoginResult)
	resp.Err = 0
	a.WriteMsg(resp)
	log.Debug("++++++++++++++++++login %v %v %v", m.Acc, m.Psw, m.Pid)
}
