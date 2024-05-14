import { BillingDirection, BillingInfo, BillingInfoUtils, DBManager, Logger, StringUtils } from '@ohos/common';
import router from '@ohos.router';
import { EntryViewer } from './EntryViewer';
import promptAction from '@ohos.promptAction';

let TAG = "INDEX";

@Entry
@Component
struct Index {
  @State selectedDate: number =Date.parse(new Date().toString());
  @State currentBillingInfo: BillingInfo[] = [];
  @State totalIncome: number = 0.00;
  @State totalBalance: number = 0.00;

  clearCache() {
    this.totalIncome = 0;
    this.totalBalance = 0;
  }

  onPageShow() {
    DBManager.getInstance().getAllBillingInfo()
      .then(r => {
        this.clearCache();
        this.currentBillingInfo = r;
        this.currentBillingInfo.forEach(info => {
          info.direction == BillingDirection.IN ? this.totalIncome += info.amount : this.totalBalance += info.amount;
        })
        Logger.info(TAG, "get info success ", r);
        Logger.info(TAG, "explode length: ", BillingInfoUtils.explodeMonthlyArray(this.currentBillingInfo, new Date())[19]
          .length)
      })
  }

  private controller: TabsController = new TabsController();
  @State index: number = 0; // 选项卡下标，默认为第一个

  @Builder tab1() {
    Column() {
      Column() {
        Blank()
        // Image('$r("app.media.tab1Icon")')
        //   .size({width: 25, height: 25})
        Text('记账')
          .fontSize(17)
          .fontColor(this.index == 0 ? "#2a58d0" : "#6b6b6b")
        Blank()
      }
      .height('100%')
      .width("100%")
      .onClick(() => {
        this.index = 0;
        this.controller.changeIndex(this.index);
      })
    }
  }

  @Builder tab2() {
    Column() {
      Blank()
      // Image(this.index == 1 ? 'pages/icon_contract_selected.png' : 'pages/icon_contract_normal.png')
      //   .size({width: 25, height: 25})
      Text('报表')
        .fontSize(17)
        .fontColor(this.index == 1 ? "#2a58d0" : "#6b6b6b")
      Blank()
    }
    .height('100%')
    .width("100%")
    .onClick(() => {
      this.index = 1;
      this.controller.changeIndex(this.index);
    })
  }

  @Builder tab3() {
    Column() {
      Blank()
      // Image(this.index == 2 ? 'pages/icon_dynamic_selected.png' : 'pages/icon_dynamic_normal.png')
      //   .size({width: 25, height: 25})
      Text('我的')
        .fontSize(17)
        .fontColor(this.index == 2 ? "#2a58d0" : "#6b6b6b")
      Blank()
    }
    .height('100%')
    .width("100%")
    .onClick(() => {
      this.index = 2;
      this.controller.changeIndex(this.index);
    })
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End, // TabBar排列在下方
        controller: this.controller   // 绑定控制器
      }) {
        TabContent() {
          Column(){
            Row(){
              EntryViewer({
                selectedDate: $selectedDate,
                currentBillingInfo: $currentBillingInfo,
                totalIncome: $totalIncome,
                totalBalance: $totalBalance
              })
            }
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.tab1)

        TabContent() {
          Column() {
            Row() {
              Text($r("app.string.app_title"))
                .fontColor(Color.White)
                .fontSize(24)
                .fontWeight(FontWeight.Normal)
                .textAlign(TextAlign.Center)
                .width('100%')
            }
            .padding(24)
            .width('100%')
            .backgroundColor($r("app.color.main_theme"))

            Row() {
              Blank()
            }.height('3%')

            Button({ type: ButtonType.Capsule }) {
              Column() {
                Text("年度账单")
                  .fontSize(16)
                  .width('100%')
                  .height('6%')
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
              }
            }.stateEffect(false).width('90%')
            .backgroundColor($r("app.color.main_theme")).onClick(() => {
              router.pushUrl({
                url: "pages/BillInfoPage",
                params: {
                  activeDate: this.selectedDate
                }
              })
            }).borderRadius(8)

            Row() {
              Blank()
            }.height('3%')

            Button({ type: ButtonType.Capsule }) {
              Column() {
                Text("收入分类汇总")
                  .fontSize(16)
                  .width('100%')
                  .height('6%')
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
              }
            }.stateEffect(false).width('90%')
            .backgroundColor($r("app.color.main_theme")).onClick(() => {
              router.pushUrl({
                url: "pages/BillAggPage",
                params: {
                  billType : BillingDirection.IN
                }
              })
            }).borderRadius(8)

            Row() {
              Blank()
            }.height('3%')

            Button({ type: ButtonType.Capsule }) {
              Column() {
                Text("支出分类汇总")
                  .fontSize(16)
                  .width('100%')
                  .height('6%')
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
              }
            }.stateEffect(false).width('90%')
            .backgroundColor($r("app.color.main_theme")).onClick(() => {
              router.pushUrl({
                url: "pages/BillAggPage",
                params: {
                  billType : BillingDirection.OUT
                }
              })
            }).borderRadius(8)

          }
          .width('100%')
          .height('100%')

          // .backgroundColor("#bbccaa")
        }
        .tabBar(this.tab2)

        TabContent() {
          Column() {
            Row() {
              Text($r("app.string.app_title"))
                .fontColor(Color.White)
                .fontSize(24)
                .fontWeight(FontWeight.Normal)
                .textAlign(TextAlign.Center)
                .width('100%')
                .padding(24)
                .backgroundColor($r("app.color.main_theme"))
            }
            Row() {
              Blank()
            }.height('3%')

            Button({ type: ButtonType.Capsule }) {
              Column() {
                Text("个性化设置")
                  .fontSize(16)
                  .width('100%')
                  .height('6%')
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
              }
            }.stateEffect(false).width('90%')
            .backgroundColor($r("app.color.main_theme")).onClick(() => {
              promptAction.showDialog({
                title: "提示",
                message: "该功能开发中",
                buttons: [
                  {
                    text: "确认",
                    color: $r("app.color.main_theme")
                  }
                ]
              });
            }).borderRadius(8)

            Row() {
              Blank()
            }.height('3%')

            Button({ type: ButtonType.Capsule }) {
              Column() {
                Text("账单备份和恢复")
                  .fontSize(16)
                  .width('100%')
                  .height('6%')
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
              }
            }.stateEffect(false).width('90%')
            .backgroundColor($r("app.color.main_theme")).onClick(() => {
              promptAction.showDialog({
                title: "提示",
                message: "该功能开发中",
                buttons: [
                  {
                    text: "确认",
                    color: $r("app.color.main_theme")
                  }
                ]
              });

            }).borderRadius(8)

            Row() {
              Blank()
            }.height('3%')

            Button({ type: ButtonType.Capsule }) {
              Column() {
                Text("查看开发者信息")
                  .fontSize(16)
                  .width('100%')
                  .height('6%')
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
              }
            }.stateEffect(false).width('90%')
            .backgroundColor($r("app.color.main_theme")).onClick(() => {
              router.pushUrl({
                url: "pages/Copyright",
              })
            }).borderRadius(8)

          }
          .width('100%')
          .height('100%')
          // .backgroundColor("#ccaabb")
        }
        .tabBar(this.tab3)
      }
      .width('100%')
      .height('100%')
      .barHeight(60)
      .barMode(BarMode.Fixed)         // TabBar均分
      .onChange((index: number) => {  // 页面切换回调
        this.index = index;
      })
    }
    .width('100%')
    .height('100%')
  }
}
