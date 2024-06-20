import { getVideoReplay ,submitReplay } from '../http/apiService';
import { BaseViewModel, ResultCallback } from '../viewmodel/BaseViewModel';
import UserModel from '../viewmodel/UserViewModel'

export interface ReplyItem {
  user_img: ResourceStr // 头像
  lickname: string // 作者
  id?: number // 评论的id
  content: string // 评论内容
  time: string // 发表时间
  area: string // 地区
}
export class DetailViewModel extends BaseViewModel{
  relationId:number = -1
  tabTitle = [
    {
      index: 0,
      title: "相关视频",
      imageActivated: $r('app.media.icon_sel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    },
    {
      index: 1,
      title: "评论",
      imageActivated: $r('app.media.icon_sel_find'),
      imageOriginal: $r('app.media.icon_unsel_find')
    }
  ]

  async getViedoReplay(resultCallBack?:ResultCallback){
      await this.httpRequest()
        .promise(getVideoReplay(this.relationId))
        .then(result => {
            if(+result.code === 200){
                resultCallBack?.(result.data)
            }else{
              resultCallBack?.([])
            }
        })
  }

  async submitReplay(replay:ReplyItemModel,resultCallBack?:ResultCallback){
      await this.httpRequest()
        .promise(submitReplay(this.relationId,UserModel.getUser().id,replay))
        .then(result => {
            resultCallBack?.(result)
        })
  }
}
let detailViewModel = new DetailViewModel();
export default detailViewModel as DetailViewModel

export class ReplyItemModel implements ReplyItem {
  id: number = 0
  user_img: string | Resource = ''
  lickname: string = ''
  content: string = ''
  time: string = ''
  area: string = ''

  constructor(model: ReplyItem) {
    this.id = model.id
    this.user_img = model.user_img
    this.lickname = model.lickname
    this.content = model.content
    this.time = model.time
    this.area = model.area
  }
}

export enum CommentType {
  MAIN,// 顶部
  NORMAL// 普通
}
export const mockReplyList: ReplyItemModel[] = [
  new ReplyItemModel({
    id: 1,
    user_img: 'https://picx.zhimg.com/027729d02bdf060e24973c3726fea9da_l.jpg?source=06d4cd63',
    lickname: '偏执狂-妄想家',
    content: '更何况还分到一个摩洛哥[惊喜]',
    time: '11-30',
    area: '海南',
  }),
  new ReplyItemModel({
    id: 2,
    user_img: 'https://pic1.zhimg.com/v2-5a3f5190369ae59c12bee33abfe0c5cc_xl.jpg?source=32738c0c',
    lickname: 'William',
    content: '当年希腊可是把1：0发挥到极致了',
    time: '11-29',
    area: '北京',
  }),
  new ReplyItemModel({
    id: 3,
    user_img: 'https://picx.zhimg.com/v2-e6f4605c16e4378572a96dad7eaaf2b0_l.jpg?source=06d4cd63',
    lickname: 'Andy Garcia',
    content: '欧洲杯其实16队球队打正赛已经差不多，24队打正赛意味着正赛阶段在小组赛一样有弱队。',
    time: '11-28',
    area: '上海',
  }),
  new ReplyItemModel({
    id: 4,
    user_img: 'https://picx.zhimg.com/v2-53e7cf84228e26f419d924c2bf8d5d70_l.jpg?source=06d4cd63',
    lickname: '正宗好鱼头',
    content: '确实眼红啊，亚洲就没这种球队，让中国队刷',
    time: '11-27',
    area: '香港',
  }),
  new ReplyItemModel({
    id: 5,
    user_img: 'https://pic1.zhimg.com/v2-eeddfaae049df2a407ff37540894c8ce_l.jpg?source=06d4cd63',
    lickname: '柱子哥',
    content: '我是支持扩大的，亚洲杯欧洲杯扩到32队，世界杯扩到64队才是好的，世界上有超过200支队伍，欧洲区55支队伍，亚洲区47支队伍，即使如此也就六成出现率',
    time: '11-27',
    area: '旧金山',
  }),
  new ReplyItemModel({
    id: 6,
    user_img: 'https://picx.zhimg.com/v2-fab3da929232ae911e92bf8137d11f3a_l.jpg?source=06d4cd63',
    lickname: '飞轩逸',
    content: '禁止欧洲杯扩军之前，应该先禁止世界杯扩军，或者至少把亚洲名额一半给欧洲。',
    time: '11-26',
    area: '里约',
  })
]

