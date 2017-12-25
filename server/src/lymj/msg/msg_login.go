package msg

type Msg2Login struct { // 登录
	Acc string
	Psw string
	Pid int
}

type RespLoginResult struct {
	Err int
}
