import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:flutter_svg/flutter_svg.dart' as vg;

class JointMinMaxChartDesignValue {
  final JointMinMaxChartSVGStruct hipKneeSVG;
  final double canvasWidth;
  final double canvasHeight;
  final double legendWidth;
  final double legendHeight;
  final double legendToLegendInset;
  final double legendLineTextInset;
  final double legendLineTopInset;
  final double svgWidth;
  final double svgHeight;
  final double svgContainerHeight;
  final double svgContainerTop;
  // svg 위치와 크기가 설정이 안됨 그래서 svg 파일에 위치와 크기를 하드 코딩을 함 이를 참고 부탁드립니다.
  // 나중에 svg 교체를 하더라도 이를 설정해야함을 유의하세요.
  final double svgTop;
  final double yAxisInset;

  final double graphCanvasWidth;
  final double graphCanvasHeight;
  final double xAxisStart;
  final double yAxisStart;
  final double halfPaddingRightLeftLine;
  final double min;
  final double max;
  final double radius;
  final int xAxisLineNumber;
  JointMinMaxChartDesignValue(
      {required this.hipKneeSVG,
      required this.canvasWidth,
      required this.canvasHeight,
      required this.legendWidth,
      required this.legendHeight,
      required this.legendToLegendInset,
      required this.legendLineTextInset,
      required this.legendLineTopInset,
      required this.svgWidth,
      required this.svgHeight,
      required this.svgContainerHeight,
      required this.svgContainerTop,
      required this.svgTop,
      required this.yAxisInset,
      required this.graphCanvasWidth,
      required this.graphCanvasHeight,
      required this.xAxisStart,
      required this.yAxisStart,
      required this.halfPaddingRightLeftLine,
      required this.min,
      required this.max,
      required this.radius,
      required this.xAxisLineNumber});
  factory JointMinMaxChartDesignValue.getBy(double widthRatio, double heightRatio, HipKneeEnum type, bool isKorean) {
    int tXAxisLineNumber;
    double tmin;
    double tmax;
    if (type == HipKneeEnum.HIP) {
      tmin = -20;
      tmax = 100;
      tXAxisLineNumber = 7;
    } else {
      tmin = -20;
      tmax = 120;
      tXAxisLineNumber = 8;
    }
    return JointMinMaxChartDesignValue(
        hipKneeSVG: JointMinMaxChartSVGStruct(),
        canvasWidth: 260 * widthRatio, //230 * widthRatio,
        canvasHeight: 122 * heightRatio,
        legendWidth: 16 * widthRatio,
        legendHeight: 12 * heightRatio,
        legendToLegendInset: 12 * widthRatio,
        legendLineTextInset: 4 * widthRatio,
        legendLineTopInset: isKorean ? 6 * heightRatio : 4.5 * heightRatio,
        svgWidth: 32 * widthRatio,
        svgHeight: 40 * heightRatio,
        svgContainerHeight: 56 * heightRatio,
        svgContainerTop: (35 + 12) * heightRatio,
        svgTop: (35 + 12) * heightRatio,
        yAxisInset: 8 * widthRatio,
        graphCanvasWidth: 152 * widthRatio,
        graphCanvasHeight: 80 * heightRatio,
        xAxisStart: (32 + 8 + 14) * widthRatio,
        yAxisStart: (12 + 16 + 80) * heightRatio,
        halfPaddingRightLeftLine: 13 * heightRatio, // (10 + 16)/2
        min: tmin,
        max: tmax,
        radius: 2 * widthRatio,
        xAxisLineNumber: tXAxisLineNumber);
  }
  Future<List<vg.PictureInfo>> getHipImages() async {
    final hipExtensionPictureInfo = await vg.vg.loadPicture(vg.SvgStringLoader(hipKneeSVG.hipExtensionSVG), null);
    final hipFlexionPictureInfo = await vg.vg.loadPicture(vg.SvgStringLoader(hipKneeSVG.hipFlexionSVG), null);
    return [hipExtensionPictureInfo, hipFlexionPictureInfo];
  }

  Future<List<vg.PictureInfo>> getKneeImages() async {
    final kneeExtensionPictureInfo = await vg.vg.loadPicture(vg.SvgStringLoader(hipKneeSVG.kneeExtensionSVG), null);
    final kneeFlexionPictureInfo = await vg.vg.loadPicture(vg.SvgStringLoader(hipKneeSVG.kneeFlexionSVG), null);
    return [kneeExtensionPictureInfo, kneeFlexionPictureInfo];
  }
}

class JointMinMaxChartSVGStruct {
  // illust_angle_4.svg – 무릎 굽힘 (knee flexion, right side)
  final String kneeFlexionSVG = """
<svg width="32" height="40" viewBox="0 0 32 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<path opacity="0.3" d="M19.9468 20.9875C19.9468 20.9875 20.0991 21.1652 19.7166 23.4215C19.2529 26.1539 19.0735 27.8838 20.1194 31.6286C21.1652 35.3735 19.9569 36.6474 19.9569 36.6474C19.9569 36.6474 18.6707 39.0378 21.3243 39.0378C23.9779 39.0378 23.4972 38.7193 26.3911 38.8769C29.285 39.0345 30.4933 37.841 29.6065 37.442C28.7198 37.043 23.4939 37.1235 23.0911 33.2982C22.7729 30.2708 23.7003 26.7372 24.0625 24.6821C24.2554 23.5958 24.5025 22.5197 24.8071 21.4569C25.3216 19.6633 25.9579 16.9779 25.8834 14.916" stroke="#B1B1B1" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M7.0783 13.3971L7.97184 13.434L6.66199 11.8013L5.22351 13.3267L6.0629 13.3602C6.07644 14.7482 6.54352 27.2801 18.1021 36.8517L18.7519 36.0807C7.61307 26.8544 7.0986 14.832 7.0783 13.3971Z" fill="url(#paint0_linear_287_10994)"/>
<path d="M28.0597 1.15019C28.6216 5.25375 25.8868 14.7348 25.8868 14.7348C25.8868 14.7348 23.8763 21.4266 21.304 21.1886C18.7317 20.9505 17.6046 19.9146 13.5836 15.2947C9.56266 10.6749 10.6897 8.28448 8.27649 8.60298C6.18816 8.87789 4.0423 11.1811 3.50076 11.798C3.38906 11.9254 3.25706 12.0226 3.10137 12.093C2.68506 12.2774 1.96413 12.435 2.24505 11.1174C2.38721 10.4536 2.71213 9.84343 3.15552 9.33049C3.84937 8.53257 5.06108 6.92669 5.61954 4.93861C6.13739 3.08463 7.36264 2.89688 8.1648 2.99411C8.59465 3.04775 8.97034 3.30255 9.18019 3.67804C9.57281 4.39214 10.3513 5.69964 11.0891 6.37351C12.135 7.329 19.0938 12.5858 19.8181 15.5328C19.8181 15.5328 18.691 13.0217 19.0532 7.16807C19.0532 7.16807 16.0781 4.93861 18.3289 0.714355" stroke="#818181" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<defs>
<linearGradient id="paint0_linear_287_10994" x1="6.74999" y1="11.8649" x2="18.4131" y2="36.7599" gradientUnits="userSpaceOnUse">
<stop stop-color="#000047"/>
<stop offset="1" stop-color="#000047" stop-opacity="0"/>
</linearGradient>
</defs>
</svg>
""";
  // illust_angle_3.svg – 무릎 폄 (knee extension, left side)
  final String kneeExtensionSVG = """
<svg width="32" height="40" viewBox="0 0 32 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<path opacity="0.3" d="M25.8718 14.3833C25.8718 14.3833 23.8734 21.0984 21.3166 20.8595C18.7597 20.6206 17.6394 19.5811 13.6427 14.9451C9.64592 10.3091 10.7662 7.91039 8.3675 8.23C6.29174 8.50587 4.15879 10.8171 3.6205 11.4362C3.50948 11.564 3.37828 11.6616 3.22352 11.7322C2.80971 11.9172 2.09312 12.0754 2.37236 10.7532C2.51366 10.0871 2.83663 9.47478 3.27735 8.96004C3.96702 8.15935 5.17143 6.54786 5.72654 4.55284C6.24127 2.6924 7.45914 2.504 8.25648 2.60156C8.68374 2.65539 9.05717 2.91107 9.26576 3.28787C9.65602 4.00446 10.4298 5.31653 11.1632 5.99275C12.2028 6.95157 18.3594 13.0275 19.076 13.0275" stroke="#B1B1B1" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M18.0667 36.406L17.7707 34.3336L17.2021 34.9863C5.91832 24.7353 6.54407 11.8266 6.5508 11.6987L5.54488 11.6382C5.53815 11.7728 4.86866 25.1592 16.5393 35.7466L15.9741 36.3959L18.0667 36.406Z" fill="url(#paint0_linear_287_10989)"/>
<path d="M18.4368 0.714355C18.4368 0.714355 16.0381 3.43269 18.8371 7.42945C18.8371 7.42945 18.2787 12.3077 20.0348 15.0226C20.0348 15.0226 20.5933 20.6982 19.7152 23.3357C18.8371 25.9733 19.076 27.8136 20.1156 31.5715C21.1551 35.3294 19.9541 36.6078 19.9541 36.6078C19.9541 36.6078 18.6757 39.0065 21.3133 39.0065C23.9508 39.0065 23.4731 38.6869 26.3496 38.8451C29.226 39.0032 30.4271 37.8055 29.5456 37.4051C28.6642 37.0048 23.4698 37.0855 23.0694 33.2469C22.6691 29.4083 24.1897 23.975 24.109 22.535C24.0282 21.0951 28.2706 7.8298 27.6314 0.875841" stroke="#818181" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<defs>
<linearGradient id="paint0_linear_287_10989" x1="17.9523" y1="36.4328" x2="5.50451" y2="11.5372" gradientUnits="userSpaceOnUse">
<stop stop-color="#000047"/>
<stop offset="1" stop-color="#000047" stop-opacity="0"/>
</linearGradient>
</defs>
</svg>
""";
  // illust_angle_2.svg – 엉덩 굽힘 (hip flexion, right side)
  final String hipFlexionSVG = """
<svg width="32" height="40" viewBox="0 0 32 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.36248 2.85742C3.36248 2.85742 -0.47619 7.37646 5.88302 10.311C5.88302 10.311 8.63182 14.1518 11.6121 15.28C14.5924 16.4082 15.5665 17.9895 15.5665 17.9895C15.5665 17.9895 16.0262 21.5483 23.9897 27.7596C23.9897 27.7596 25.1343 30.2442 26.6839 28.0987C28.2335 25.9533 28.002 25.7822 29.378 24.7681C30.754 23.754 30.6383 21.8874 30.066 21.8874C29.4937 21.8874 27.1436 25.2751 24.9092 24.7681C22.6748 24.261 21.2409 17.8216 19.0065 16.6902C19.0065 16.6902 14.8238 9.68668 12.3612 7.7092C9.89851 5.73173 9.77956 3.31059 9.77956 3.31059" stroke="#818181" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M4.05053 9.354C4.05053 9.354 3.07639 13.873 3.64865 20.6484C3.64865 20.6484 3.82227 20.9781 3.18891 22.9079C2.38517 24.9425 4.33344 30.3615 4.33344 32.339C4.33344 34.3164 2.6713 36.576 4.96358 36.576C7.25585 36.576 9.14625 36.351 10.9209 36.7439C12.6956 37.1369 13.0396 36.6298 13.0396 36.0087C13.0396 35.3876 7.36837 35.6126 6.9665 32.2249C6.56463 28.8372 7.19477 23.8111 7.08224 22.2836C6.96972 20.7562 9.44846 14.1646 9.44846 14.1646" stroke="#818181" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M21.0995 30.0571L20.7555 27.3159L18.0549 28.0575L18.968 28.6564C16.3864 32.4783 10.5062 31.7716 10.4483 31.7652L10.413 33.0043C10.4869 33.0138 10.8856 33.0962 11.6797 33.0962C13.808 33.0962 17.8331 32.624 20.0386 29.3599L21.1027 30.0571H21.0995Z" fill="url(#paint0_linear_268_4344)"/>
<defs>
<linearGradient id="paint0_linear_268_4344" x1="21.0224" y1="27.3159" x2="10.4746" y2="32.6663" gradientUnits="userSpaceOnUse">
<stop stop-color="#000047"/>
<stop offset="1" stop-color="#000047" stop-opacity="0"/>
</linearGradient>
</defs>
</svg>
""";
  // illust_angle_1.svg – 엉덩 폄 (hip extension, left side)
  final String hipExtensionSVG = """
<svg width="32" height="40" viewBox="0 0 32 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M18.3181 2.85742C18.3181 2.85742 15.3304 4.55233 16.3263 10.0195C16.3263 10.0195 13.6448 12.2523 12.8809 16.2579C12.8809 16.2579 12.4974 18.5685 11.2727 19.4144C10.0479 20.2602 6.84752 24.1945 5.39072 27.5065C5.39072 27.5065 4.74612 29.1269 3.92748 29.2857C2.16773 29.8074 2.69306 31.5801 4.0725 32.1958C5.45194 32.8116 6.37049 32.7338 7.74994 34.1208C9.12938 35.5079 11.5015 35.3523 11.5789 34.7366C11.6562 34.1208 6.59933 31.1167 7.21492 29.8074C7.83051 28.4982 13.2065 23.3519 14.7374 21.3491C16.2683 19.3463 25.5183 8.55464 25.3636 4.16668" stroke="#818181" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M18.9305 16.1638C18.9305 16.1638 19.1594 19.3364 18.9305 22.3406C18.7017 25.3447 17.477 24.1133 19.0852 31.2721C19.0852 31.2721 20.0811 33.735 19.5461 35.1221C19.0111 36.5091 19.0852 37.585 20.9997 37.4327C22.9141 37.2804 24.2162 37.2026 25.7472 37.5105C27.2781 37.8183 28.4287 37.2804 28.4287 36.5869C28.4287 35.8933 22.4565 36.5091 22.2244 32.429C21.9924 28.3489 22.9915 23.1896 22.5306 22.6484C22.5306 22.6484 25.7472 13.717 24.8286 6.86279" stroke="#818181" stroke-width="0.8" stroke-miterlimit="10" stroke-linecap="round"/>
<path d="M17.7154 32.1958L17.609 30.9513C17.5736 30.9578 14.0605 31.4213 11.8238 29.6939L12.5489 28.8027L9.7417 28.8773L10.2284 31.6578L11.0116 30.6953C12.6585 31.9851 14.8373 32.2444 16.3166 32.2444C17.2448 32.2444 17.6509 32.2055 17.7186 32.1958H17.7154Z" fill="url(#paint0_linear_268_4297)"/>
<defs>
<linearGradient id="paint0_linear_268_4297" x1="9.74174" y1="28.8027" x2="17.661" y2="31.7788" gradientUnits="userSpaceOnUse">
<stop stop-color="#000047"/>
<stop offset="1" stop-color="#000047" stop-opacity="0"/>
</linearGradient>
</defs>
</svg>
""";
}
