import { toLogin, toRegister } from '../http/apiService';
import { LoginUser, User } from '../model/UserModel';
import { LogUtils } from '../utils/LogUtils';
import { BaseViewModel, ResultCallback, StateCallback } from './BaseViewModel';

export class UserViewModel extends BaseViewModel{

    private loginuser:LoginUser = null;
    private user:User = null;


    getUser(){ return this.user }
  /**
   * 登录-axios客户端请求
   * @param stateCallback  状态返回
   * @param resultCallback  结果返回
   */
    async toLogin(loginuser:LoginUser,stateCallback:StateCallback){
      await this.httpRequest()
        .promise(toLogin(loginuser))
        .then(result => {
          console.log(result)
            if(+result?.code === 200){
                this.user = result?.data;
            }else{
              LogUtils.debug("LoginTag", "错误1>>>>>>");
            }
          stateCallback?.(result?.code);
        })
    }
  /**
   * 注册-axios客户端请求
   * @param stateCallback  状态返回
   * @param resultCallback  结果返回
   */
  async toRegister(user:User,resultCallback:ResultCallback){
    await this.httpRequest()
      .promise(toRegister(user))
      .then(result => {
        console.log(result)
        if(+result?.code === 200){
          this.user = {...user};
          this.user.id = result?.data.insertId;
        }
        resultCallback?.(result)
      })
  }

}
let userViewModel = new UserViewModel();
export default userViewModel as UserViewModel