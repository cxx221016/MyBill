// Copyright (c) 2023 Ericple
// OpenBill is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
// http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.
import router from '@ohos.router';

@Entry
@Component
struct Copyright {
  build(){
    Row(){
      Column(){
        Image($r("app.media.authorAvatar")).width(128).height(128)
        Text("Float & Cxx")
          .fontSize(24)
          .margin(12)
          .fontWeight(FontWeight.Bold)
          .fontColor('black')
        Text("Mail: aleryxiao@sjtu.edu.cn")
          .fontColor('black')
          .margin(12)
          .fontColor('black')
        Text("Group: 上海交通大学")
          .fontColor('black')
          .margin(12)
          .fontColor('black')

        Row() {
          Blank()
        }.height('4%')

        Button({ type: ButtonType.Capsule }) {
          Column() {
            Text("确认")
              .fontSize(16)
              .width('100%')
              .height('6%')
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
          }
        }.stateEffect(false).width('90%')
        .backgroundColor($r("app.color.main_theme")).onClick(() => {
          router.back();
        }).borderRadius(8)

      }.width('100%')
    }.height('90%').backgroundColor('white')
  }
}