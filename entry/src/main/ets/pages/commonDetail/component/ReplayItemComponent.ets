import { ReplyItem, ReplyItemModel } from '../../../model/ReplayModel'

@Preview
@Component
struct ZhiHuComponentItem {
  item: ReplyItemModel = new ReplyItemModel({} as ReplyItem)
  changeLike: () => void = () => {
  }

  build() {
    Row({ space: 10 }) {
      Image(this.item.avatar)
        .width(28)
        .borderRadius(14)
      Column() {
        Text(this.item.author)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Text(this.item.content)
          .fontSize(13)
          .maxLines(3)
          .lineHeight(18)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 8 })
          .padding({ bottom: 12 })
        Row({ space: 5 }) {
          Text(`${this.item.time} IP归属地${this.item.area}`)
            .fontSize(12)
            .fontColor('#999999')
          Row({ space: 3 }) {
            Image($r('app.media.default_avatar'))
              .width(12)
              .fillColor(this.item.likeFlag ? Color.Red : Color.Black)
            Text(this.item.likeNum.toString())
              .fontSize(12)
              .fontColor('#999999')
          }
          .onClick(() => {
            this.changeLike()
          })
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
}

@Component
struct ZhiHuReply {
  @State content: string = ''
  onSubmitContent: (content: string) => void = () => {
  }

  submitContent() {
    if (this.content) {
      this.onSubmitContent(this.content)
      this.content = ''
    }
  }

  build() {
    Row({ space: 15 }) {
      TextInput({ placeholder: '请输入', text: $$this.content })
        .layoutWeight(1)
        .height(40)
        .onSubmit(() => {
          this.submitContent()
        })
      Button('发布')
        .onClick(() => {
          this.submitContent()
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
export { ZhiHuComponentItem,ZhiHuReply }
