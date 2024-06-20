import { ViewStateConstant } from '../../../constants/ViewStateConstant'
import { mockReplyList, ReplyItemModel, ReplyItem } from '../../../model/ReplayModel'
import { StateComponent } from '../../../views/StateComponent'
import  DetailViewModel  from '../../../model/ReplayModel'
import UserViewModel from '../../../viewmodel/UserViewModel'
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl'
import common from '@ohos.app.ability.common'
import geoLocationManager from '@ohos.geoLocationManager'

@Preview
@Component
export struct ReplayBottomComponent {
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING
  @State content: string = ''
  @State commentList: ReplyItem[] = mockReplyList
  @State mAdministrativeArea: string = '' // 省份
  private scroller: Scroller = new Scroller()
  private relationId: number

  aboutToAppear(){
    DetailViewModel.observeState(state => this.viewState = state)
    DetailViewModel.relationId = this.relationId
    this.loadNet()
  }
  loadNet(){
    DetailViewModel.getViedoReplay(result => {
      this.commentList = result
      this.getLocation()
    })
  }
  async getLocation(){
    let status = await this.reqPermissionsFromUser(['ohos.permission.LOCATION','ohos.permission.APPROXIMATELY_LOCATION'])
    if(status){
      let location = geoLocationManager.getLastLocation()
      console.log('lucy',JSON.stringify(location))
      location['locale'] = 'zh'
      //逆地理编码服务
      geoLocationManager.getAddressesFromLocation(location,(err,data: any)=>{
        if(!err){
          console.log('lucy--',JSON.stringify(data))
          this.mAdministrativeArea = data[0].administrativeArea
        }
      })
    }
  }

  // 检测权限是否已经授权，如果未授权就弹出授权弹窗
  reqPermissionsFromUser(permissions: Array<Permissions>){
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    return atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续操作
          return true
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          return false
        }
      }
      // 授权成功
    }).catch((err) => {
      console.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
    })
  }
  /**
   * 提交评论
   * @param content
   */
  onSubmitContent(content: string) {
    const replyItem = new ReplyItemModel({
      lickname: UserViewModel.getUser().lickname,
      user_img: UserViewModel.getUser().user_img,
      time: `${(new Date().getMonth() + 1).toString().padStart(2, '0')}-${new Date().getDate()}`,
      area: this.mAdministrativeArea,
      content:this.content
    })
    DetailViewModel.submitReplay(replyItem,result => {
      if(+result.code === 200){
        this.commentList = result.data
        this.content = ''
      }else{
        AlertDialog.show({
          title: '提示',
          message: '评论失败，请稍后重试',
          autoCancel: true,
          alignment: DialogAlignment.Bottom,
          offset: { dx: 0, dy: -60 },
          gridCount: 3,
          confirm: {
            value: '确定',
            action: () => {}
          }
        })
      }
    })
    this.scroller.scrollEdge(Edge.Top)
  }

  build() {
    Column() {
      StateComponent({ viewState: this.viewState, retryCallback: () => {
        this.loadNet()
      }}){
        // 评论数
        Column(){
          Row() {
            Text(`评论数${this.commentList.length}`)
          }
          .width('100%')
          .height(50)
          .padding({ left: 20 })
          .border({
            color: '#f3f4f5',
            width: {
              bottom: 1
            }
          })
          // 普通评论列表
          List({ scroller: this.scroller }) {
            ForEach(this.commentList, (item: ReplyItemModel) => {
              ListItem() {
                this.replayItemBuilder(item)
              }
            })
          }
          .layoutWeight(1)
          this.replayInputBuilder()
        }

      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
  }

  @Builder
  replayItemBuilder(item:ReplyItemModel){
    Row({ space: 10 }) {
      Image(item.user_img)
        .width(28)
        .borderRadius(14)
      Column() {
        Text(item.lickname)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Text(item.content)
          .fontSize(13)
          .maxLines(3)
          .lineHeight(18)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 8 })
          .padding({ bottom: 12 })
        Row({ space: 5 }) {
          Text(`${item.time} IP归属地  ${item.area}`)
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .padding(20)
  }
  @Builder
  replayInputBuilder(){
    Row({ space: 15 }) {

      TextInput({ placeholder: '请输入', text: this.content })
        .layoutWeight(1)
        .height(40)
        .onChange(value => {
          this.content = value
        })
      Button('发布')
        .onClick(() => {
          this.onSubmitContent(this.content)
        })
    }
    .height(60)
    .width('100%')
    .padding({
      left: 20,
      right: 20
    })
    .border({
      color: '#e5e5e5',
      width: {
        top: 1
      }
    })
  }
}
