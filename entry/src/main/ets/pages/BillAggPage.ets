import { BillingDirection, BillingInfo, BillingInfoUtils, BillingType, DBManager, StringUtils } from '@ohos/common';
import {

  ColorTemplate,        // 颜色模板
  EntryOhos,            // 图表数据结构基础类


  JArrayList,           // 工具类：数据集合
  Legend,               // 图表Legend(图例)部件
  MPPointF,             // MPPointF

  PieChart,             // 饼状图组件
  PieData,              // 饼状图数据包
  PieDataSet,           PieEntry,           // 饼状图数据集合
  SeekBar,
  BarChart,BarChartModel, YAxis, XAxis, BarDataSet, AxisDependency, YAxisLabelPosition, XAxisPosition, BarEntry, IBarDataSet, BarData
} from '@ohos/mpchart';
import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { billingInfoList } from '../data/balanceTypes';
import { DateUtils } from '@ohos/common/src/main/ets/Utils/DateUtils';

@Entry
@Component
struct BillAggPage{
  @State billType :BillingDirection = router.getParams()['billType'];
  @State beginTime: number = DateUtils.getFirstDate()
  @State endTime : number = Date.parse(new Date().toString())
  @State billInfoList : BillingInfo[]=[]
  billingType2CntMap : Map<string,number>=new Map<string,number>()
  @State pieModel: PieChart.Model = new PieChart.Model()

  // @State barModel:BarChartModel = new BarChartModel()
  // m_width: number = 350; //表的宽度
  // m_height: number = 500; //表的高度
  // minOffset: number = 15; //X轴线偏移量
  // leftAxis: YAxis = null;
  // rightAxis: YAxis = null;
  // bottomAxis: XAxis = new XAxis();

  aboutToAppear() {
    // DBManager.getInstance().getAllBillingInfo()
    // .then(r => {
      this.billInfoList=billingInfoList
      this.billInfoList = BillingInfoUtils.filterByBillingDirection(this.billInfoList,this.billType);
      this.billInfoList=BillingInfoUtils.filterByDate(this.billInfoList,new Date(this.beginTime),new Date(this.endTime))
      this.billInfoList.forEach(info => {
        this.billingType2CntMap.set(info.type.name,(this.billingType2CntMap.has(info.type.name)?this.billingType2CntMap.get(info.type.name):0)+info.amount)
      })
      this.initPieModel()
      // this.initBarModel()
  }

  private initPieModel(){
    this.initPieData()

    this.pieModel
      .setRadius(150)
      .setHoleRadius(0.5)
      .setOffset(new MPPointF(200,220))
      .setUsePercentValues(true)
  }

  private initPieData(){
    let entries = new JArrayList<PieEntry>();

    for (let [key,value] of this.billingType2CntMap){
      entries.add(new PieEntry(value,key+' '+ value.toString()))
    }

    if (entries.isEmpty()){
      entries.add(new PieEntry(1,'暂无数据'))
    }
    //        entries.add(new PieEntry(4,'Party A'))
    //        entries.add(new PieEntry(2,'Party B'))
    //        entries.add(new PieEntry(5,'Party C'))
    //        entries.add(new PieEntry(3,'Party D'))

    let dataSet: PieDataSet = new PieDataSet(entries,
      "Election Results");
    dataSet.setDrawIcons(false);
    dataSet.setSliceSpace(3);
    dataSet.setIconsOffset(new MPPointF(0, 50));
    dataSet.setSelectionShift(5);

    // add a lot of colors
    let colors: JArrayList<number> = new JArrayList();
    for (let index = 0;
         index < ColorTemplate.VORDIPLOM_COLORS.length; index++) {
      colors.add(ColorTemplate.VORDIPLOM_COLORS[index]);
    }

    for (let index = 0;
         index < ColorTemplate.JOYFUL_COLORS.length; index++) {
      colors.add(ColorTemplate.JOYFUL_COLORS[index]);
    }

    for (let index = 0;
         index < ColorTemplate.COLORFUL_COLORS.length; index++) {
      colors.add(ColorTemplate.COLORFUL_COLORS[index]);
    }
    for (let index = 0;
         index < ColorTemplate.LIBERTY_COLORS.length; index++) {
      colors.add(ColorTemplate.LIBERTY_COLORS[index]);
    }
    for (let index = 0;
         index < ColorTemplate.PASTEL_COLORS.length; index++) {
      colors.add(ColorTemplate.PASTEL_COLORS[index]);
    }
    colors.add(ColorTemplate.getHoloBlue());
    dataSet.setColorsByList(colors);
    this.pieModel
        .setPieData(new PieData(dataSet))
  }


  build(){
    Column(){
      Column() {
        Button({ type: ButtonType.Normal }) {
          Row() {
            Text('开始时间:')
              .fontSize(16)
              .fontColor(Color.White)

            Text(StringUtils.formatDate(this.beginTime, 'Y'))
              .fontSize(16)
              .fontColor(Color.White)
            Text($r("app.string.year"))
              .fontColor($r('app.color.text_white'))
              .fontColor($r('app.color.text_white'))
              .fontSize(16)
              .align(Alignment.Bottom)
              .height(22)
              .margin(2)

            Text(StringUtils.formatDate(this.beginTime, 'M'))
              .fontSize(16)
              .fontColor(Color.White)
            Text($r("app.string.month"))
              .fontColor($r('app.color.text_white'))
              .fontSize(16)
              .align(Alignment.Bottom)
              .height(22)
              .margin(2)
            Image($r("app.media.ic_public_extract_list_light"))
              .width(8).height(8).margin({ top: 6, left: 8 })
          }
        }.onClick(() => {
          DatePickerDialog.show({
            start: new Date(`2000-01-01`),
            selected: new Date(this.beginTime),
            onAccept: (v) => {
              this.beginTime=DateUtils.get000Date().setFullYear(v.year, v.month, v.day);
              this.aboutToAppear()
            }
          });
        })
        .backgroundColor($r('app.color.main_theme'))
        .width('100%')
        .padding(6)

        // Row() {
        //   Blank()
        // }.height('5%')

        Button({ type: ButtonType.Normal }) {
          Row() {
            Text('结束时间:')
              .fontSize(16)
              .fontColor(Color.White)

            Text(StringUtils.formatDate(this.endTime, 'Y'))
              .fontSize(16)
              .fontColor(Color.White)
            Text($r("app.string.year"))
              .fontColor($r('app.color.text_white'))
              .fontSize(16)
              .align(Alignment.Bottom)
              .height(22)
              .margin(2)

            Text(StringUtils.formatDate(this.endTime, 'M'))
              .fontSize(16)
              .fontColor(Color.White)
            Text($r("app.string.month"))
              .fontColor($r('app.color.text_white'))
              .fontSize(16)
              .align(Alignment.Bottom)
              .height(22)
              .margin(2)
            Image($r("app.media.ic_public_extract_list_light"))
              .width(8).height(8).margin({ top: 6, left: 8 })
          }
        }.onClick(() => {
          DatePickerDialog.show({
            start: new Date(`2000-01-01`),
            selected: new Date(this.endTime),
            onAccept: (v) => {
              this.endTime=new Date().setFullYear(v.year, v.month, v.day);
              this.aboutToAppear()
            }
          });
        })
        .backgroundColor($r('app.color.main_theme'))
        .width('100%')
        // .borderRadius(4)
        .padding(6)

      }
      .width('100%')
      .border({
        style: BorderStyle.Solid,
        color: { right: "gray" },
        width: { right: 1 }
      })

      PieChart({
        model: this.pieModel,
      })


    }
    .height('100%')
  }
}
