import router from '@ohos.router';
import Queue from '@ohos.util.Queue';
import promptAction from '@ohos.promptAction';
import {RoutePath} from "../../route/RoutePath"
import UserViewModel from '../../viewmodel/UserViewModel';
@Entry
@Component
struct Register {
  scroller: Scroller = new Scroller();
  @State username:string = '';
  @State password:string = '';
  @State reword:string = '';
  @State user_img:string = '';
  @State lickname:string = '';
  @State isOn:boolean = false;
  build() {
    Row() {
      Column() {
        Row() {
          Column()  {
            Text('添加一个账号')
              .fontSize(30)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Normal)
          }.width('100%')
        }.backgroundColor($r('app.color.color_red')).height('10%')
        Row() {
          Column() {Text('\n\n\n')
            Image($r('app.media.default_avatar')).height(150).width(150).borderRadius(15).syncLoad(true)
            Text('\n\n')
            Text('  欢迎注册  ')
              .fontColor($r('app.color.color_red'))
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
            Text('\n\n\n\n\n\n\n\n\n')
          }
        }.backgroundColor(Color.White).height('30%')
        Row() {
          Text('账号：')
          TextInput({placeholder:'Account'}).width(260).type(InputType.Normal).onChange(value=>{
            this.username = value;
          })
        }.height('5%')
        Row() {
          Text('密码：')
          TextInput({placeholder:'Password'}).width(260).type(InputType.Password).onChange(value=>{
            this.password = value
          })
        }.height('10%')
        Row(){
          Text('密码: ')
          TextInput({placeholder:'Password Again'}).width(260).type(InputType.Password).onChange(value=>{
            this.reword = value;
          })
        }.height("5%")
        Row(){
          Text('昵称: ')
          TextInput({placeholder:'Password Again'}).width(260).type(InputType.Normal).onChange(value=>{
            this.lickname = value;
          })
        }.height("10%")
        Row(){
          Text('头像: ')
          TextInput({placeholder:'Avator',text:this.user_img}).width(260).type(InputType.Normal).onChange(value=>{
            this.user_img = value;
          })
        }.height("5%")
        Row() {
          Toggle({ type: ToggleType.Checkbox, isOn: false })
            .selectedColor(Color.Orange).onChange(value=>{
              this.isOn = value
          })
          Text('我已阅读并同意《用户协议》和《隐私保护指引》').fontSize(13)
        }.height('10%')
        Row()
        {
          Button('注册', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(10)
            .backgroundColor($r("app.color.color_voliet"))
            .width(250)
            .onClick(()=>{
              if(this.isOn){
                if(this.password === this.reword){
                  UserViewModel.toRegister({"username":this.username,"password":this.password,"user_img":this.user_img,lickname:this.lickname},result=>{
                    if(+result?.code === 200){
                      router.pushUrl({url:RoutePath.LoginPage})
                    }else{
                      AlertDialog.show({
                        title: '提示',
                        message: '用户注册失败,请重试',
                        autoCancel: true,
                        // 设置弹框在底部
                        alignment: DialogAlignment.Bottom,
                        // 设置弹框底部向上移动60
                        offset: { dx: 0, dy: -60 },
                        gridCount: 3,
                        confirm: {
                          value: '确定',
                          action: () => {}
                        }
                      })
                    }
                  })
                }else{
                  AlertDialog.show({
                    title: '提示',
                    message: '两次输入密码不一致',
                    autoCancel: true,
                    // 设置弹框在底部
                    alignment: DialogAlignment.Bottom,
                    // 设置弹框底部向上移动60
                    offset: { dx: 0, dy: -60 },
                    gridCount: 3,
                    confirm: {
                      value: '确定',
                      action: () => {}
                    }
                  })
                }
              }else{
                AlertDialog.show({
                  title: '提示',
                  message: '请阅读并勾选用户协议',
                  autoCancel: true,
                  // 设置弹框在底部
                  alignment: DialogAlignment.Bottom,
                  // 设置弹框底部向上移动60
                  offset: { dx: 0, dy: -60 },
                  gridCount: 3,
                  confirm: {
                    value: '确定',
                    action: () => {}
                  }
                })
              }

            })
        }.height('10%')
        Row() {
          Text('已有账号?返回登录').fontSize(13).fontColor(Color.Blue).onClick(()=>{
            router.pushUrl({ url: RoutePath.LoginPage })
          })
        }.height('5%')
      }
    }
  }
}