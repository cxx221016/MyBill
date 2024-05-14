export class DateUtils {
  public static getDayNumByJSMonth(date: Date): number {
    let m = date.getMonth() + 1;
    let y = date.getFullYear()
    if (m == 2)
      return y % 4 ? 28 : 29;
    if (m < 8)
      return m % 2 ? 31 : 30;
    return m % 2 ? 30 : 31;
  }

  public static getFirstDate(): number{
    let data=new Date();
    data.setDate(1);
    data.setHours(0);
    data.setSeconds(0);
    data.setMinutes(0);
    return Date.parse(data.toString())
  }

  public static get000Date(): Date{
    let data=new Date();
    data.setHours(0);
    data.setSeconds(0);
    data.setMinutes(0);
    return data
  }
}