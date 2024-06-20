import router from '@ohos.router'
import DetailViewModel from '../../model/ReplayModel'
import { CommonTopBar } from '../../views/CommonTopBar'
import { VideoComponent } from '../../views/VideoComponent'
import { LogUtils } from '../../utils/LogUtils'
import { VideoBottomComponent } from './component/VideoBottomComponent'
import { TabItem } from '../../model/TabItem'
import { CommonConstants } from '../../constants/CommonConstants'
import { ReplayBottomComponent } from './component/ReplayBottomComponent'

@Entry
@Component
@Preview
struct DetailPage {
  @State isAutoPlay: boolean = true
  @State showControls: boolean = true
  @State playUrl: string = ""
  @State relationId: number = -1
  @State selectedIndex: number = 0
  private controller: VideoController = new VideoController()

  aboutToAppear() {
    this.relationId = router.getParams()['id']
    this.playUrl = router.getParams()['playUrl']
  }

  build() {
    Column() {
      CommonTopBar({ title: '视频详情', alpha: 1 })
      this.headerPlayer()
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.Start,
      }) {
        TabContent() {
          VideoBottomComponent({
            relationId: this.relationId,
            onItemClick: (playUrl) => {
              this.playUrl = playUrl
            }
          })
        }
        .tabBar(DetailViewModel.tabTitle[0].title)

        TabContent() {
          ReplayBottomComponent({relationId: this.relationId}).layoutWeight(1)
        }
        .tabBar(DetailViewModel.tabTitle[1].title)

      }
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .scrollable(false)
      .barHeight('36vp')
      .onChange((index: number) => {
        this.selectedIndex = index;
      })
      .layoutWeight(1)

    }
    .layoutWeight(1)


  }


  @Builder
  headerPlayer() {
    VideoComponent({ showControls: $showControls, playUrl: $playUrl, isAutoPlay: this.isAutoPlay })
      .width('100%')
      .height($r('app.float.size_250'))

  }
}