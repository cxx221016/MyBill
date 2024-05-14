import { BillingDirection, BillingInfo, BillingInfoUtils, BillingType, DBManager } from '@ohos/common';
import {

  ColorTemplate,        // 颜色模板
  EntryOhos,            // 图表数据结构基础类


  JArrayList,           // 工具类：数据集合
  Legend,               // 图表Legend(图例)部件
  MPPointF,             // MPPointF

  PieChart,             // 饼状图组件
  PieData,              // 饼状图数据包
  PieDataSet,           PieEntry,           // 饼状图数据集合
  SeekBar
} from '@ohos/mpchart';
import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { billingInfoList } from '../data/balanceTypes';

@Entry
@Component
struct BillAggPage{
  @State billType :BillingDirection = router.getParams()['billType'];
  pieData: PieData =null
  @State billInfoList : BillingInfo[]=[]
  billingType2CntMap : Map<string,number>=new Map<string,number>()
  @State pieModel: PieChart.Model = new PieChart.Model()
  // @State @Watch("seekBarXValueWatch")
  seekBarX: SeekBar.Model = new SeekBar.Model()
  // @State @Watch("seekBarYValueWatch")
  seekBarY: SeekBar.Model = new SeekBar.Model()


  aboutToAppear() {
    // DBManager.getInstance().getAllBillingInfo()
    // .then(r => {
    this.billInfoList=billingInfoList
    this.billInfoList = BillingInfoUtils.filterByBillingDirection(this.billInfoList,this.billType);
    hilog.info(1,"1",this.billInfoList.length.toString())
    this.billInfoList.forEach(info => {
      this.billingType2CntMap.set(info.type.name,(this.billingType2CntMap.has(info.type.name)?this.billingType2CntMap.get(info.type.name):0)+info.amount)
    })
    this.pieData=this.initPieData(this.billingType2CntMap)
    this.pieModel
      .setPieData(this.pieData)
      .setRadius(150)
      .setHoleRadius(0.5)
      .setOffset(new MPPointF(200,220))
    // })
    this.pieModel.setUsePercentValues(true)

  }


  private initPieData(billingType2CntMap :Map<string,number>): PieData{
    let entries = new JArrayList<PieEntry>();

    for (let [key,value] of billingType2CntMap){
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
    return new PieData(dataSet)
  }




  build(){
    Column(){
      Text("年结余").fontSize(14).margin(4).height(22)

      PieChart({
        model: this.pieModel,
      })
    }
    .height('100%')
  }
}function delay(arg0: number) {
  throw new Error('Function not implemented.');
}
