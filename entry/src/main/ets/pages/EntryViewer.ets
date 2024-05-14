// Copyright (c) 2023 Ericple
// OpenBill is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
// http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

import { BalanceViewer } from '../components/BalanceViewer';
import { BalanceList } from '../components/BalanceList';
import {DBManager, Logger } from '@ohos/common';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { advancedTemplate } from '../data/defaultBalanceTemplate';
import { StringUtils } from '@ohos/common';
import router from '@ohos.router';

@Component
export struct EntryViewer {
  @Link selectedDate: number;
  @Link currentBillingInfo: string;
  @Link totalIncome: number;
  @Link totalBalance: number;
  build() {
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

      BalanceViewer({
        selectedDate: $selectedDate,
        currentBillingInfo: $currentBillingInfo,
        totalIncome: $totalIncome,
        totalBalance: $totalBalance
      })

      // PageEntries()
      Row() {
        Blank()
      }.height('3%')

      Button({ type: ButtonType.Capsule }) {
        Column() {
          Text("记一笔")
            .fontSize(16)
            .width('100%')
            .height('6%')
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
        }
      }
      .stateEffect(false)
      .width('90%')
      .backgroundColor($r("app.color.main_theme"))
      .onClick(() => {
        router.pushUrl({
          url: "pages/addBalance",
          params: {
            year: new Date(this.selectedDate).getFullYear(),
            month: new Date(this.selectedDate).getMonth() + 1
          }
        })
      })
      .borderRadius(8)

      Row() {
        Blank()
      }.height('3%')


      Text('近期消费')
        .fontSize(14)
        .textAlign(TextAlign.Start)

      Row() {
        Blank()
      }.height('3%')

      BalanceList({
        currentBillingInfo: $currentBillingInfo,
        selectedDate: $selectedDate,
        totalBalance: $totalBalance,
        totalIncome: $totalIncome
      })
    }
  }
}