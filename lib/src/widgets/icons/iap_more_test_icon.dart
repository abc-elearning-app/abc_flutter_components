import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/index.dart';

class IAPMoreTestIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const IAPMoreTestIcon({super.key, this.color, this.height, this.width = 120});

  String getIconContent(String color) {
    return '''
      <svg width="142" height="135" viewBox="0 0 142 135" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M79.1721 9.38164C87.9128 8.41683 95.4491 12.3985 99.1928 20.2715C108.73 40.3013 112.433 31.5431 124.121 42.4934C142.259 59.4972 113.359 69.1399 122.21 88.8982C127.635 101.005 119.78 124.765 101.651 118.29C80.9839 110.899 78.1966 122.141 60.9135 121.829C40.8339 121.477 39.5294 107.621 34.7903 99.0543C29.7627 89.9647 12.7887 89.5118 11.0366 74.6503C9.65256 62.8652 23.8194 61.2968 18.762 35.9876C15.9548 21.9103 30.4995 8.04499 44.1384 11.8851C65.3335 17.8484 65.3534 10.9103 79.1721 9.38164Z" fill="$color" fill-opacity="0.1" />
      <path d="M8.95946 38.2526C8.96941 39.5495 9.50728 40.7163 10.3535 41.5709C11.2097 42.4454 12.394 42.9787 13.6978 42.9787C14.4744 42.9787 15.1018 43.6122 15.1018 44.3965C15.1018 45.1807 14.4744 45.8242 13.6978 45.8242C12.3933 45.8242 11.2089 46.3574 10.3535 47.232C9.48739 48.0965 8.95946 49.2932 8.95946 50.6107C8.95946 51.3949 8.33207 52.0284 7.55548 52.0284C6.77889 52.0284 6.14232 51.3942 6.14232 50.6107C6.14232 49.2932 5.61439 48.0965 4.74828 47.232C3.89212 46.3574 2.70697 45.8242 1.40321 45.8242C0.627392 45.8242 0 45.1807 0 44.3965C0 43.6122 0.627392 42.9787 1.40321 42.9787C2.70773 42.9787 3.89212 42.4454 4.74828 41.5709C5.5945 40.7163 6.13161 39.5495 6.14232 38.2526C6.14232 38.2327 6.14232 38.2121 6.14232 38.1922C6.14232 37.4079 6.77889 36.7744 7.55548 36.7744C8.33207 36.7744 8.95946 37.4079 8.95946 38.1922C8.95946 38.2121 8.95946 38.2327 8.95946 38.2526Z" fill="$color" fill-opacity="0.1" />
      <path d="M115.739 7.25569C115.748 8.15087 116.117 8.97566 116.704 9.56862C117.312 10.1715 118.138 10.5533 119.044 10.5533C119.582 10.5533 120.019 10.9956 120.019 11.5388C120.019 12.082 119.582 12.5235 119.044 12.5235C118.138 12.5235 117.312 12.906 116.704 13.5089C116.107 14.1126 115.739 14.9573 115.739 15.8724C115.739 16.4148 115.301 16.8571 114.753 16.8571C114.215 16.8571 113.778 16.4141 113.778 15.8724C113.778 14.9573 113.399 14.1126 112.802 13.5089C112.205 12.9053 111.378 12.5235 110.462 12.5235C109.925 12.5235 109.487 12.0812 109.487 11.5388C109.487 10.9956 109.925 10.5533 110.462 10.5533C111.378 10.5533 112.204 10.1708 112.802 9.56862C113.39 8.97566 113.768 8.15087 113.778 7.25569C113.778 7.2358 113.778 7.22508 113.778 7.20519C113.778 6.66196 114.215 6.21973 114.753 6.21973C115.301 6.21973 115.739 6.66196 115.739 7.20519C115.739 7.22508 115.739 7.2358 115.739 7.25569Z" fill="$color" fill-opacity="0.1" />
      <path d="M21.4895 95.6802C21.4995 96.5853 21.8683 97.4002 22.4551 98.0031C23.0626 98.606 23.8889 98.9778 24.7948 98.9778C25.3327 98.9778 25.7703 99.4201 25.7703 99.9733C25.7703 100.516 25.3327 100.959 24.7948 100.959C23.8889 100.959 23.0626 101.341 22.4551 101.944C21.8575 102.547 21.4895 103.383 21.4895 104.297C21.4895 104.85 21.0519 105.292 20.5041 105.292C19.9662 105.292 19.5278 104.85 19.5278 104.297C19.5278 103.383 19.1498 102.547 18.5523 101.944C17.9547 101.341 17.1284 100.959 16.2233 100.959C15.6754 100.959 15.2378 100.516 15.2378 99.9733C15.2378 99.4201 15.6762 98.9778 16.2233 98.9778C17.1291 98.9778 17.9547 98.606 18.5523 98.0031C19.1399 97.3994 19.5178 96.5853 19.5278 95.6802C19.5278 95.6703 19.5278 95.6504 19.5278 95.6404C19.5278 95.0972 19.9662 94.645 20.5041 94.645C21.0519 94.645 21.4895 95.0972 21.4895 95.6404C21.4895 95.6504 21.4895 95.6703 21.4895 95.6802Z" fill="$color"/>
      <path d="M92.0283 122.925C92.0482 124.011 92.4866 124.987 93.1935 125.7C93.9204 126.435 94.9059 126.887 96.0007 126.887C96.648 126.887 97.1759 127.41 97.1759 128.074C97.1759 128.727 96.6488 129.261 96.0007 129.261C94.9059 129.261 93.9196 129.713 93.1935 130.437C92.4774 131.161 92.0283 132.167 92.0283 133.263C92.0283 133.926 91.5003 134.459 90.8538 134.459C90.2065 134.459 89.6794 133.927 89.6794 133.263C89.6794 132.167 89.231 131.161 88.5149 130.437C87.788 129.713 86.8026 129.261 85.7069 129.261C85.0604 129.261 84.5325 128.728 84.5325 128.074C84.5325 127.411 85.0604 126.887 85.7069 126.887C86.8018 126.887 87.788 126.435 88.5149 125.7C89.2218 124.987 89.6595 124.011 89.6794 122.925C89.6794 122.905 89.6794 122.895 89.6794 122.875C89.6794 122.222 90.2065 121.688 90.8538 121.688C91.5011 121.688 92.0283 122.222 92.0283 122.875C92.0283 122.896 92.0283 122.906 92.0283 122.925Z" fill="$color" fill-opacity="0.1" />
      <path d="M136.477 78.2059C136.497 79.3627 136.966 80.4079 137.722 81.1722C138.489 81.9465 139.544 82.4186 140.709 82.4186C141.406 82.4186 141.963 82.9917 141.963 83.6856C141.963 84.3895 141.406 84.9526 140.709 84.9526C139.545 84.9526 138.489 85.4354 137.722 86.2097C136.956 86.984 136.477 88.0598 136.477 89.2266C136.477 89.9305 135.92 90.4936 135.223 90.4936C134.536 90.4936 133.969 89.9305 133.969 89.2266C133.969 88.0598 133.491 86.984 132.725 86.2097C131.958 85.4354 130.903 84.9526 129.738 84.9526C129.051 84.9526 128.484 84.3895 128.484 83.6856C128.484 82.9917 129.051 82.4186 129.738 82.4186C130.903 82.4186 131.959 81.9458 132.725 81.1722C133.481 80.4079 133.96 79.362 133.969 78.2059C133.969 78.186 133.969 78.1661 133.969 78.1454C133.969 77.4515 134.526 76.8784 135.223 76.8784C135.92 76.8784 136.477 77.4515 136.477 78.1454C136.477 78.1653 136.477 78.1852 136.477 78.2059Z" fill="$color"/>
      <path d="M53.9349 0.905127C53.9449 1.67942 54.2632 2.39327 54.7811 2.91661C55.2991 3.43918 56.016 3.76052 56.8018 3.76052C57.28 3.76052 57.658 4.15303 57.658 4.62587C57.658 5.0987 57.28 5.4805 56.8018 5.4805C56.016 5.4805 55.2991 5.81179 54.7811 6.33513C54.2532 6.86764 53.9349 7.5922 53.9349 8.38639C53.9349 8.85923 53.557 9.25173 53.0788 9.25173C52.6105 9.25173 52.2333 8.85923 52.2333 8.38639C52.2333 7.5922 51.9051 6.86841 51.3871 6.33513C50.8691 5.81255 50.143 5.4805 49.3557 5.4805C48.8875 5.4805 48.5095 5.09794 48.5095 4.62587C48.5095 4.15303 48.8875 3.76052 49.3557 3.76052C50.1423 3.76052 50.8691 3.43918 51.3871 2.91661C51.8951 2.39327 52.2234 1.68019 52.2333 0.905127C52.2333 0.885234 52.2333 0.875288 52.2333 0.864576C52.2333 0.381791 52.6113 0 53.0788 0C53.557 0 53.9349 0.381791 53.9349 0.864576C53.9349 0.875288 53.9349 0.885234 53.9349 0.905127Z" fill="$color"/>
      <path d="M92.0274 69.7791C92.376 70.1196 92.9261 70.1237 93.2706 69.7793V69.7793C93.8313 69.2188 94.7983 69.6085 94.7983 70.4013V93C94.7983 94.1046 93.9029 95 92.7983 95H51C49.8954 95 49 94.1046 49 93V37C49 35.8954 49.8954 35 51 35H94.3337C94.6164 35 94.8457 35.2292 94.8457 35.512V35.512C94.8457 41.0655 94.843 46.6204 94.8524 52.1739C94.8524 52.5198 94.7726 52.7791 94.5128 53.0196C94.2982 53.2177 94.0858 53.418 93.8737 53.6205C93.0922 54.3665 91.8647 54.3681 91.0914 53.6135C90.3478 52.888 89.5985 52.1568 88.8435 51.4201C88.054 50.6497 86.7898 50.6641 86.0181 51.4523C84.4048 53.1001 82.7981 54.7417 81.1832 56.3911C80.4097 57.1811 80.4238 58.4488 81.2148 59.2213C84.8223 62.7443 88.418 66.254 92.0274 69.7791ZM55.1212 42.076C55.1212 42.7557 55.6722 43.3067 56.3519 43.3067H86.4478C87.1275 43.3067 87.6785 42.7557 87.6785 42.076V42.076C87.6785 41.3963 87.1275 40.8453 86.4478 40.8453H56.3519C55.6722 40.8453 55.1212 41.3963 55.1212 42.076V42.076ZM82.0363 49.5816C82.0363 48.9049 81.4877 48.3563 80.811 48.3563H56.4872C55.8105 48.3563 55.262 48.9049 55.262 49.5816V49.5816C55.262 50.2583 55.8105 50.8068 56.4872 50.8068H80.811C81.4877 50.8068 82.0363 50.2583 82.0363 49.5816V49.5816ZM56.5102 69.618C55.823 69.618 55.266 70.1751 55.266 70.8622V70.8622C55.266 71.5493 55.823 72.1064 56.5102 72.1064H80.7691C81.4562 72.1064 82.0133 71.5493 82.0133 70.8622V70.8622C82.0133 70.1751 81.4562 69.618 80.7691 69.618H56.5102ZM75.4861 60.2084C75.4861 59.4589 74.8786 58.8514 74.1291 58.8514H62.0109C61.2614 58.8514 60.6539 59.4589 60.6539 60.2084V60.2084C60.6539 60.9578 61.2614 61.5654 62.0109 61.5654H74.1291C74.8786 61.5654 75.4861 60.9578 75.4861 60.2084V60.2084ZM60.6377 76.1185C60.6377 76.8646 61.2425 77.4694 61.9885 77.4694H74.1217C74.8678 77.4694 75.4726 76.8646 75.4726 76.1185V76.1185C75.4726 75.3725 74.8678 74.7676 74.1217 74.7676H61.9885C61.2425 74.7676 60.6377 75.3725 60.6377 76.1185V76.1185ZM61.996 64.2374C61.2488 64.2374 60.6431 64.8431 60.6431 65.5903V65.5903C60.6431 66.3375 61.2488 66.9433 61.996 66.9433H71.147C71.8942 66.9433 72.4999 66.3375 72.4999 65.5903V65.5903C72.4999 64.8431 71.8942 64.2374 71.147 64.2374H61.996ZM60.6336 86.8852C60.6336 87.6268 61.2348 88.228 61.9764 88.228H71.1666C71.9082 88.228 72.5094 87.6268 72.5094 86.8852V86.8852C72.5094 86.1436 71.9082 85.5424 71.1666 85.5424H61.9764C61.2348 85.5424 60.6336 86.1436 60.6336 86.8852V86.8852ZM69.6803 56.1969C70.4394 56.1969 71.0548 55.5815 71.0548 54.8224V54.8224C71.0548 54.0632 70.4394 53.4478 69.6803 53.4478H62.0311C61.272 53.4478 60.6566 54.0632 60.6566 54.8224V54.8224C60.6566 55.5815 61.272 56.1969 62.0311 56.1969H69.6803ZM61.9994 80.1523C61.254 80.1523 60.6498 80.7565 60.6498 81.5019V81.5019C60.6498 82.2472 61.254 82.8514 61.9994 82.8514H69.2155C69.9608 82.8514 70.565 82.2472 70.565 81.5019V81.5019C70.565 80.7565 69.9608 80.1523 69.2155 80.1523H61.9994ZM57.7367 65.7396C57.7205 64.8859 56.891 64.2644 55.9913 64.5941C55.6273 64.7278 55.3553 65.0453 55.2714 65.4235C55.0766 66.2948 55.6814 67.0135 56.4973 67.0054C57.1914 66.9973 57.7502 66.4272 57.7367 65.7396ZM57.7394 54.9527C57.7286 54.2719 57.1535 53.6991 56.4811 53.7004C55.7775 53.7018 55.2119 54.2921 55.2335 55.0027C55.2552 55.693 55.8275 56.2469 56.5068 56.2307C57.1819 56.2145 57.7502 55.6255 57.7394 54.9527ZM57.738 60.3685C57.738 59.6957 57.1657 59.1027 56.5027 59.0878C55.8424 59.0743 55.2417 59.6592 55.2322 60.3252C55.2227 61.0615 55.7585 61.6113 56.4851 61.6086C57.1874 61.6059 57.738 61.0615 57.738 60.3685ZM57.7394 76.259C57.7326 75.5863 57.1508 74.9973 56.4892 74.9932C55.8262 74.9892 55.2349 75.5768 55.2322 76.2442C55.2295 76.9777 55.7721 77.5208 56.5 77.514C57.1968 77.5059 57.7462 76.9493 57.7394 76.259ZM57.734 81.5991C57.7015 80.9048 57.0751 80.3604 56.3796 80.413C55.7206 80.4644 55.2268 80.9939 55.2349 81.6613C55.243 82.3732 55.7802 82.9054 56.4878 82.9027C57.209 82.9 57.7692 82.3205 57.734 81.5991ZM57.7394 87.05C57.7313 86.3273 57.1684 85.7882 56.4405 85.8045C55.7396 85.8207 55.2173 86.3732 55.2335 87.0811C55.2498 87.7592 55.8384 88.3374 56.4986 88.3252C57.1603 88.3117 57.7475 87.7092 57.7394 87.05Z" fill="$color"/>
      <path d="M103.292 47.4514C104.089 46.6432 105.399 46.6598 106.175 47.4882C106.678 48.0251 107.18 48.561 107.686 49.1005C108.42 49.8839 108.405 51.1071 107.651 51.8719C103.177 56.4127 98.6235 61.0337 94.0476 65.6783C93.2747 66.4629 92.0128 66.4749 91.225 65.7051C89.0147 63.5454 86.8091 61.3903 84.5807 59.2131C83.7646 58.4158 83.7798 57.0983 84.6139 56.3198C85.1516 55.818 85.6879 55.3173 86.2262 54.815C87.0071 54.086 88.223 54.0998 88.9874 54.8462C89.6836 55.526 90.4017 56.2273 91.134 56.9424C91.9214 57.7113 93.1822 57.6996 93.9551 56.916C97.055 53.7737 100.154 50.6324 103.292 47.4514Z" fill="$color"/>
      <path d="M56.3513 43.3067C55.672 43.3067 55.1213 42.7529 55.1213 42.0736V42.0736C55.1213 41.3943 55.672 40.8467 56.3513 40.8467C66.3903 40.8467 76.4038 40.8467 86.4486 40.8467C87.1279 40.8467 87.6786 41.3822 87.6786 42.0615V42.0615C87.6786 42.7408 87.1279 43.3067 86.4486 43.3067C76.4359 43.3067 66.4149 43.3067 56.3513 43.3067Z" fill="white"/>
      <path d="M80.811 48.3563C81.4877 48.3563 82.0363 48.9033 82.0363 49.58V49.58C82.0363 50.2567 81.4877 50.8068 80.811 50.8068C72.7093 50.8068 64.6135 50.8068 56.4873 50.8068C55.8106 50.8068 55.262 50.2709 55.262 49.5942V49.5942C55.262 48.9175 55.8105 48.3563 56.4872 48.3563C64.5768 48.3563 72.6745 48.3563 80.811 48.3563Z" fill="white"/>
      <path d="M55.2661 70.881C55.2661 70.1938 55.8231 69.618 56.5103 69.618C64.6074 69.618 72.6742 69.618 80.7691 69.618C81.4562 69.618 82.0133 70.166 82.0133 70.8531V70.8531C82.0133 71.5402 81.4563 72.1064 80.7691 72.1064C72.6949 72.1064 64.6201 72.1064 56.5103 72.1064C55.8231 72.1064 55.2661 71.5681 55.2661 70.881V70.881Z" fill="white"/>
      <path d="M74.1291 58.8514C74.8785 58.8514 75.4861 59.4676 75.4861 60.217V60.217C75.4861 60.9664 74.8786 61.5654 74.1291 61.5654C70.0928 61.5654 66.0644 61.5654 62.0109 61.5654C61.2614 61.5654 60.6539 60.9756 60.6539 60.2261V60.2261C60.6539 59.4767 61.2614 58.8514 62.0108 58.8514C66.0418 58.8514 70.0701 58.8514 74.1291 58.8514Z" fill="white"/>
      <path d="M61.9885 77.4694C61.2425 77.4694 60.6376 76.8671 60.6376 76.1211V76.1211C60.6376 75.375 61.2425 74.7676 61.9885 74.7676C66.0299 74.7676 70.0694 74.7676 74.1217 74.7676C74.8677 74.7676 75.4726 75.3714 75.4726 76.1175V76.1175C75.4726 76.8636 74.8677 77.4694 74.1217 77.4694C70.079 77.4694 66.053 77.4694 61.9885 77.4694Z" fill="white"/>
      <path d="M60.6431 65.604C60.6431 64.8568 61.2488 64.2374 61.996 64.2374C65.0579 64.2374 68.0932 64.2374 71.147 64.2374C71.8942 64.2374 72.4999 64.834 72.4999 65.5812V65.5812C72.4999 66.3284 71.8942 66.9433 71.147 66.9433C68.1076 66.9433 65.0604 66.9433 61.996 66.9433C61.2488 66.9433 60.6431 66.3512 60.6431 65.604V65.604Z" fill="white"/>
      <path d="M61.9764 88.228C61.2348 88.228 60.6336 87.6268 60.6336 86.8852V86.8852C60.6336 86.1436 61.2348 85.5424 61.9764 85.5424C65.0366 85.5424 68.0934 85.5424 71.1666 85.5424C71.9082 85.5424 72.5094 86.1365 72.5094 86.8781V86.8781C72.5094 87.6197 71.9082 88.228 71.1666 88.228C68.1088 88.228 65.0578 88.228 61.9764 88.228Z" fill="white"/>
      <path d="M71.0548 54.797C71.0548 55.5562 70.4394 56.1969 69.6803 56.1969C67.1313 56.1969 64.5911 56.1969 62.0311 56.1969C61.272 56.1969 60.6566 55.5926 60.6566 54.8335V54.8335C60.6566 54.0744 61.2719 53.4478 62.0311 53.4478C64.5699 53.4478 67.115 53.4478 69.6803 53.4478C70.4394 53.4478 71.0548 54.0379 71.0548 54.797V54.797Z" fill="white"/>
      <path d="M60.6498 81.5176C60.6498 80.7722 61.2541 80.1523 61.9994 80.1523C64.4107 80.1523 66.8078 80.1523 69.2155 80.1523C69.9608 80.1523 70.5651 80.756 70.5651 81.5014V81.5014C70.5651 82.2467 69.9608 82.8514 69.2155 82.8514C66.8107 82.8514 64.4135 82.8514 61.9994 82.8514C61.2541 82.8514 60.6498 82.2629 60.6498 81.5176V81.5176Z" fill="white"/>
      <path d="M57.7367 65.7396C57.7502 66.4272 57.1901 66.9973 56.496 67.0054C55.791 67.0135 55.243 66.4772 55.2336 65.7693C55.2227 65.0628 55.7585 64.5144 56.4662 64.5049C57.1644 64.4954 57.7232 65.0399 57.7367 65.7396Z" fill="white"/>
      <path d="M57.7394 54.9527C57.7503 55.6255 57.182 56.2144 56.5068 56.2307C55.8289 56.2469 55.2552 55.6943 55.2336 55.0027C55.2119 54.2921 55.7762 53.7018 56.4811 53.7004C57.1536 53.6991 57.7286 54.2719 57.7394 54.9527Z" fill="white"/>
      <path d="M57.7381 60.3685C57.7367 61.0615 57.1874 61.6059 56.4865 61.6086C55.7599 61.6113 55.2241 61.0628 55.2336 60.3252C55.2431 59.6592 55.8438 59.0743 56.5041 59.0878C57.1658 59.1013 57.7394 59.6957 57.7381 60.3685Z" fill="white"/>
      <path d="M57.7394 76.259C57.7462 76.9493 57.1968 77.5059 56.5 77.5127C55.7721 77.5208 55.2295 76.9763 55.2322 76.2428C55.2349 75.5755 55.8262 74.9878 56.4892 74.9919C57.1495 74.9973 57.7326 75.5863 57.7394 76.259Z" fill="white"/>
      <path d="M57.7353 81.6491C57.7421 82.3475 57.1914 82.9 56.4878 82.9027C55.7802 82.9054 55.243 82.3732 55.2349 81.6613C55.2268 80.9615 55.7694 80.413 56.4743 80.409C57.1725 80.4036 57.7299 80.952 57.7353 81.6491Z" fill="white"/>
      <path d="M57.7394 87.05C57.7475 87.7092 57.1603 88.3117 56.4973 88.3252C55.837 88.3374 55.2484 87.7592 55.2322 87.0811C55.2159 86.3732 55.7382 85.8207 56.4391 85.8045C57.1684 85.7883 57.7313 86.3273 57.7394 87.05Z" fill="white"/>
      </svg>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
        getIconContent(
            color ?? getHexCssColor(Theme.of(context).colorScheme.primary)),
        width: width,
        height: height);
  }
}
