import router from '@ohos.router';
import Queue from '@ohos.util.Queue';
import promptAction from '@ohos.promptAction';
import {RoutePath} from "../../route/RoutePath"
import UserViewModel from '../../viewmodel/UserViewModel';
import { StorageUtils } from '../../utils/StorageUtils';
import { StorageKeys } from '../../constants/StorageKeys';
@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller();
  @State username:string = '';
  @State password:string = '';
  @State isOn:boolean = false;
  build() {
    Row() {
      Column() {
        Row() {
          Column()  {
            Text('登录你的账号')
              .fontSize(30)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Normal)
          }.width('100%')
        }.backgroundColor($r('app.color.color_red')).height('10%')
        Row() {
          Column() {Text('\n\n\n')
            Image($r('app.media.youtube')).height(250).width(250).borderRadius(15)
            Text('\n\n\n\n\n\n')
            Text('  欢迎登录  ')
              .fontColor($r('app.color.color_red'))
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
            Text('\n\n\n\n\n\n\n\n\n')
          }
        }.backgroundColor(Color.White).height('50%')
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
        Row() {
          Toggle({ type: ToggleType.Checkbox, isOn: false })
            .selectedColor(Color.Orange).onChange(value=>{
            this.isOn = value
          })
          Text('我已阅读并同意《用户协议》和《隐私保护指引》').fontSize(13)
        }.height('10%')
        Row()
        {
          Button('登录', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(10)
            .backgroundColor($r("app.color.color_voliet"))
            .width(250)
            .onClick(()=>{
              if(this.isOn){
                UserViewModel.toLogin({"username":this.username,"password":this.password},result => {
                  if(+result === 200){
                    router.pushUrl({url:RoutePath.MainPage})
                    StorageUtils.put(StorageKeys.USER_LOGIN, true)
                  }
                  else{
                    AlertDialog.show({
                      title: '提示',
                      message: '用户名或密码错误',
                      autoCancel: true,
                      // 设置弹框在底部
                      alignment: DialogAlignment.Bottom,
                      // 设置弹框底部向上移动60
                      offset: { dx: 0, dy: -60 },
                      gridCount: 3,
                      confirm: {
                        value: '确定',
                        action: () => {}
                      },
                    })
                  }
                })
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
          Text('手机号登录').fontSize(13)
          Text('    |    ')
          Text('其他方式登录').fontSize(13)
          Text('    |    ')
          Text('没有账号?注册一个').fontSize(13).fontColor(Color.Blue).onClick(()=>{
            router.pushUrl({ url: RoutePath.RegisterPage })
          })
        }.height('5%')
      }
    }
  }
}