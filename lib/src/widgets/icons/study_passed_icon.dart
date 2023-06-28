import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/index.dart';

class StudyPassedIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const StudyPassedIcon({super.key, this.color, this.height, this.width = 120});

  String getIconContent(String color) {
    return '''
      <svg width="144" height="135" viewBox="0 0 144 135" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M79.1722 9.38164C87.9128 8.41683 95.4491 12.3985 99.1928 20.2715C108.73 40.3013 112.433 31.5431 124.121 42.4934C142.259 59.4972 113.359 69.1399 122.21 88.8982C127.635 101.005 119.78 124.765 101.651 118.29C80.9839 110.899 78.1966 122.141 60.9135 121.829C40.8339 121.477 39.5294 107.621 34.7903 99.0543C29.7628 89.9647 12.7888 89.5118 11.0367 74.6503C9.65257 62.8652 23.8194 61.2968 18.762 35.9876C15.9548 21.9103 30.4996 8.04499 44.1385 11.8851C65.3336 17.8484 65.3535 10.9103 79.1722 9.38164Z" fill="$color" fill-opacity="0.1" />
      <path d="M8.95946 38.2526C8.96941 39.5495 9.50728 40.7163 10.3535 41.5709C11.2097 42.4454 12.394 42.9787 13.6978 42.9787C14.4744 42.9787 15.1018 43.6122 15.1018 44.3965C15.1018 45.1807 14.4744 45.8242 13.6978 45.8242C12.3933 45.8242 11.2089 46.3574 10.3535 47.232C9.48739 48.0965 8.95946 49.2932 8.95946 50.6107C8.95946 51.3949 8.33207 52.0284 7.55548 52.0284C6.77889 52.0284 6.14232 51.3942 6.14232 50.6107C6.14232 49.2932 5.61439 48.0965 4.74828 47.232C3.89212 46.3574 2.70697 45.8242 1.40321 45.8242C0.627392 45.8242 0 45.1807 0 44.3965C0 43.6122 0.627392 42.9787 1.40321 42.9787C2.70773 42.9787 3.89212 42.4454 4.74828 41.5709C5.5945 40.7163 6.13161 39.5495 6.14232 38.2526C6.14232 38.2327 6.14232 38.2121 6.14232 38.1922C6.14232 37.4079 6.77889 36.7744 7.55548 36.7744C8.33207 36.7744 8.95946 37.4079 8.95946 38.1922C8.95946 38.2121 8.95946 38.2327 8.95946 38.2526Z" fill="$color" fill-opacity="0.1" />
      <path d="M115.738 7.25569C115.748 8.15087 116.116 8.97566 116.704 9.56862C117.311 10.1715 118.138 10.5533 119.044 10.5533C119.582 10.5533 120.019 10.9956 120.019 11.5388C120.019 12.082 119.582 12.5235 119.044 12.5235C118.138 12.5235 117.311 12.906 116.704 13.5089C116.106 14.1126 115.738 14.9573 115.738 15.8724C115.738 16.4148 115.301 16.8571 114.753 16.8571C114.215 16.8571 113.777 16.4141 113.777 15.8724C113.777 14.9573 113.399 14.1126 112.802 13.5089C112.205 12.9053 111.378 12.5235 110.462 12.5235C109.925 12.5235 109.487 12.0812 109.487 11.5388C109.487 10.9956 109.925 10.5533 110.462 10.5533C111.378 10.5533 112.204 10.1708 112.802 9.56862C113.389 8.97566 113.767 8.15087 113.777 7.25569C113.777 7.2358 113.777 7.22508 113.777 7.20519C113.777 6.66196 114.215 6.21973 114.753 6.21973C115.301 6.21973 115.738 6.66196 115.738 7.20519C115.738 7.22508 115.738 7.2358 115.738 7.25569Z" fill="$color" fill-opacity="0.1" />
      <path d="M6.25173 95.6802C6.26167 96.5853 6.63046 97.4002 7.2173 98.0031C7.8248 98.606 8.65112 98.9778 9.55701 98.9778C10.0949 98.9778 10.5325 99.4201 10.5325 99.9733C10.5325 100.516 10.0949 100.959 9.55701 100.959C8.65112 100.959 7.8248 101.341 7.2173 101.944C6.61975 102.547 6.25173 103.383 6.25173 104.297C6.25173 104.85 5.81408 105.292 5.26626 105.292C4.72839 105.292 4.28998 104.85 4.28998 104.297C4.28998 103.383 3.91202 102.547 3.31446 101.944C2.71691 101.341 1.89059 100.959 0.985463 100.959C0.437643 100.959 0 100.516 0 99.9733C0 99.4201 0.438408 98.9778 0.985463 98.9778C1.89136 98.9778 2.71691 98.606 3.31446 98.0031C3.90207 97.3994 4.28003 96.5853 4.28998 95.6802C4.28998 95.6703 4.28998 95.6504 4.28998 95.6404C4.28998 95.0972 4.72839 94.645 5.26626 94.645C5.81408 94.645 6.25173 95.0972 6.25173 95.6404C6.25173 95.6504 6.25173 95.6703 6.25173 95.6802Z" fill="$color"/>
      <path d="M92.0284 122.925C92.0483 124.011 92.4867 124.986 93.1936 125.7C93.9205 126.435 94.9059 126.887 96.0008 126.887C96.6481 126.887 97.176 127.41 97.176 128.074C97.176 128.727 96.6489 129.26 96.0008 129.26C94.9059 129.26 93.9197 129.712 93.1936 130.437C92.4775 131.161 92.0284 132.167 92.0284 133.263C92.0284 133.926 91.5004 134.459 90.8539 134.459C90.2066 134.459 89.6795 133.927 89.6795 133.263C89.6795 132.167 89.2311 131.161 88.515 130.437C87.7881 129.713 86.8026 129.26 85.707 129.26C85.0605 129.26 84.5326 128.728 84.5326 128.074C84.5326 127.41 85.0605 126.887 85.707 126.887C86.8019 126.887 87.7881 126.435 88.515 125.7C89.2219 124.986 89.6596 124.011 89.6795 122.925C89.6795 122.905 89.6795 122.895 89.6795 122.875C89.6795 122.221 90.2066 121.688 90.8539 121.688C91.5012 121.688 92.0284 122.221 92.0284 122.875C92.0284 122.895 92.0284 122.905 92.0284 122.925Z" fill="$color" fill-opacity="0.1" />
      <path d="M137.993 75.3275C138.013 76.4843 138.481 77.5295 139.238 78.2938C140.005 79.0681 141.06 79.5402 142.225 79.5402C142.922 79.5402 143.479 80.1132 143.479 80.8072C143.479 81.5111 142.922 82.0742 142.225 82.0742C141.06 82.0742 140.005 82.557 139.238 83.3313C138.471 84.1056 137.993 85.1813 137.993 86.3481C137.993 87.052 137.436 87.6152 136.739 87.6152C136.052 87.6152 135.485 87.052 135.485 86.3481C135.485 85.1813 135.007 84.1056 134.24 83.3313C133.474 82.557 132.419 82.0742 131.254 82.0742C130.567 82.0742 130 81.5111 130 80.8072C130 80.1132 130.567 79.5402 131.254 79.5402C132.419 79.5402 133.474 79.0673 134.24 78.2938C134.997 77.5295 135.475 76.4836 135.485 75.3275C135.485 75.3076 135.485 75.2877 135.485 75.267C135.485 74.5731 136.042 74 136.739 74C137.436 74 137.993 74.5731 137.993 75.267C137.993 75.2869 137.993 75.3068 137.993 75.3275Z" fill="$color"/>
      <path d="M53.9349 0.905127C53.9449 1.67942 54.2632 2.39327 54.7811 2.91661C55.2991 3.43918 56.016 3.76052 56.8018 3.76052C57.28 3.76052 57.658 4.15303 57.658 4.62587C57.658 5.0987 57.28 5.4805 56.8018 5.4805C56.016 5.4805 55.2991 5.81179 54.7811 6.33513C54.2532 6.86764 53.9349 7.5922 53.9349 8.38639C53.9349 8.85923 53.557 9.25173 53.0788 9.25173C52.6105 9.25173 52.2333 8.85923 52.2333 8.38639C52.2333 7.5922 51.9051 6.86841 51.3871 6.33513C50.8691 5.81255 50.143 5.4805 49.3557 5.4805C48.8875 5.4805 48.5095 5.09794 48.5095 4.62587C48.5095 4.15303 48.8875 3.76052 49.3557 3.76052C50.1423 3.76052 50.8691 3.43918 51.3871 2.91661C51.8951 2.39327 52.2234 1.68019 52.2333 0.905127C52.2333 0.885234 52.2333 0.875288 52.2333 0.864576C52.2333 0.381791 52.6113 0 53.0788 0C53.557 0 53.9349 0.381791 53.9349 0.864576C53.9349 0.875288 53.9349 0.885234 53.9349 0.905127Z" fill="$color"/>
      <rect x="49" y="31" width="44" height="66" rx="6" fill="white"/>
      <path d="M71.0145 64.4403C68.6421 62.0971 66.2717 59.7577 63.9309 57.446C62.6697 58.7103 61.3974 59.9875 60.1678 61.2184C63.7846 64.8388 67.4273 68.4852 71.2015 72.2631C78.3962 65.0298 85.6539 57.7315 92.9893 50.3554C92.9893 50.613 92.9893 50.7873 92.9893 50.9616C92.9893 64.329 92.993 77.6947 92.9875 91.0622C92.9856 93.8929 91.4541 96.008 88.8336 96.768C88.2669 96.933 87.6502 96.9886 87.0558 96.9886C76.3406 97.0016 65.6254 97.0035 54.9102 96.9942C51.4304 96.9905 49.0081 94.5825 49.0063 91.1029C48.997 73.0343 48.9989 54.9638 49.0063 36.8952C49.0044 34.1053 50.5193 32.0346 53.1323 31.2449C53.6768 31.0818 54.2676 31.0114 54.838 31.0114C65.5995 30.9984 76.3609 30.9965 87.1224 31.0058C89.9836 31.0076 92.1078 32.6074 92.7708 35.2935C92.956 36.0443 92.9634 36.8507 92.9801 37.6311C93.0115 39.0901 93.0023 40.5508 92.9763 42.0097C92.9726 42.2563 92.8726 42.5677 92.7041 42.7364C85.4965 49.9679 78.2758 57.1883 71.0571 64.4088C71.0422 64.4254 71.02 64.4366 71.0145 64.4403ZM70.9756 86.0199C69.4218 86.0236 68.2718 87.1878 68.2736 88.7524C68.2755 90.2762 69.4866 91.4774 71.0145 91.4681C72.5367 91.4589 73.7275 90.2428 73.7146 88.7116C73.7016 87.1544 72.5423 86.0162 70.9756 86.0199Z" fill="$color"/>
      <path d="M64.6448 126.183C64.5206 125.018 64.532 124.003 64.2901 123.051C63.5545 120.153 61.8348 117.848 59.6722 115.854C57.8202 114.148 55.7164 112.866 53.2742 112.171C52.5795 111.973 51.9371 112.008 51.2555 112.291C48.354 113.497 45.4901 113.275 42.6785 111.957C42.4219 111.836 42.1587 111.722 41.9151 111.576C41.5523 111.359 41.3561 111.509 41.2597 111.712C41.4329 112.029 41.5539 112.253 41.6749 112.475C41.379 112.529 41.0488 112.694 40.7938 112.614C40.4227 112.497 40.408 112.13 40.5878 111.795C41.4525 110.177 42.8077 109.203 44.5992 108.897C47.5694 108.39 50.2207 109.379 52.7855 110.734C53.119 110.911 53.4818 111.068 53.8496 111.138C56.8116 111.699 59.3338 113.157 61.673 114.971C63.7703 116.596 65.6125 118.476 66.8287 120.863C67.3223 121.83 67.6754 122.886 67.9647 123.937C68.2868 125.106 67.749 125.956 66.5524 126.187C65.9035 126.309 65.2071 126.192 64.6448 126.183Z" fill="$color"/>
      <path d="M98.06 111.733C97.944 111.355 97.622 111.429 97.2574 111.633C96.0364 112.318 94.7336 112.764 93.3474 112.96C91.5313 113.217 89.7495 113.076 88.0822 112.293C86.987 111.779 85.9915 112.099 85.014 112.491C80.7035 114.224 77.5225 117.183 75.5593 121.408C74.8874 122.855 74.5981 124.386 74.8318 126.031C74.0047 126.276 73.2201 126.456 72.424 126.101C71.3484 125.624 71.0068 124.911 71.4171 123.414C72.1249 120.836 73.601 118.737 75.4644 116.893C78.0652 114.319 81.0075 112.243 84.6119 111.357C85.8035 111.064 86.8399 110.523 87.9237 110.031C89.8035 109.175 91.7634 108.647 93.8476 108.776C95.8925 108.903 97.5043 109.809 98.5978 111.569C98.6828 111.707 98.8234 111.898 98.7826 112.006C98.6877 112.253 98.5423 112.575 98.3347 112.656C98.1499 112.728 97.8541 112.519 97.6072 112.432C97.7364 112.235 97.8639 112.037 98.06 111.733Z" fill="$color"/>
      <path d="M52.7936 110.1C50.1276 108.915 47.9388 107.256 47.2457 104.222C46.8795 102.615 47.1443 101.057 47.8227 99.4927C48.2608 99.7706 48.5125 99.9455 48.0548 100.308C47.9698 100.375 47.978 100.712 48.0679 100.817C48.3572 101.152 48.6727 101.482 49.0356 101.732C50.0916 102.456 51.2048 103.1 52.2379 103.852C53.1059 104.485 53.7908 105.292 53.9673 106.419C54.1586 107.62 53.6878 109.114 52.7936 110.1Z" fill="$color"/>
      <path d="M86.4966 110.1C84.8701 107.991 84.7639 105.739 86.7581 104.121C87.7651 103.303 88.9191 102.669 89.9849 101.92C90.4295 101.608 90.8366 101.234 91.2174 100.845C91.3825 100.676 91.5607 100.408 91.139 100.217C91.0654 100.184 91.1521 99.797 91.1717 99.457C92.4156 100.431 92.4794 103.853 91.461 105.898C90.6077 107.611 89.0924 108.899 86.4966 110.1Z" fill="$color"/>
      <path d="M41.2449 95.5173C41.549 95.9275 41.7974 96.3983 42.1669 96.7367C43.115 97.5981 44.1579 98.3566 45.088 99.2361C47.11 101.149 47.1182 103.306 44.9392 105.659C42.909 104.464 41.2172 102.968 40.493 100.617C39.8947 98.6754 40.287 96.8315 41.088 95.0416C41.1632 94.8732 41.4019 94.7768 41.5637 94.646C41.6454 94.7506 41.8187 94.8912 41.7942 94.9533C41.7272 95.1233 41.5768 95.2622 41.4591 95.4126C41.3888 95.4453 41.3169 95.4813 41.2449 95.5173Z" fill="$color"/>
      <path d="M98.0273 95.4863C97.8737 95.3702 97.8214 95.3425 97.7854 95.3016C97.6841 95.1855 97.5386 95.0744 97.5124 94.9403C97.4961 94.857 97.6726 94.6494 97.7511 94.6559C97.8835 94.6657 98.0813 94.772 98.1238 94.8848C98.4197 95.6792 98.7793 96.4687 98.9378 97.2942C99.5508 100.483 98.1957 102.87 95.7323 104.753C95.2991 105.083 94.83 105.366 94.3445 105.691C93.2738 104.402 92.3927 103.091 92.8423 101.353C93.1627 100.112 94.0764 99.2705 95.0163 98.4761C95.7781 97.832 96.5807 97.2354 97.3146 96.5619C97.622 96.2791 97.7936 95.8508 98.0273 95.4863Z" fill="$color"/>
      <path d="M45.4214 106.581C44.0974 107.445 42.8371 107.856 41.495 108.021C38.7717 108.354 36.3279 107.609 34.1146 106.043C33.7485 105.783 33.4755 105.698 33.3006 106.046C33.4428 106.353 33.5458 106.571 33.6471 106.79C33.3741 106.839 33.0652 106.993 32.838 106.913C32.431 106.77 32.4032 106.388 32.6337 106.053C33.4379 104.887 34.5151 104.089 35.8948 103.732C37.9806 103.192 39.9519 103.679 41.8269 104.544C43.0316 105.098 44.1448 105.848 45.4214 106.581Z" fill="$color"/>
      <path d="M106.042 106.139C105.846 105.641 105.524 105.798 105.167 106.054C103.456 107.29 101.55 108 99.4364 108.088C97.5222 108.168 95.7323 107.725 93.9326 106.623C94.8725 106.033 95.6882 105.441 96.5709 104.98C98.5079 103.967 100.54 103.284 102.779 103.602C104.375 103.83 105.628 104.634 106.585 105.915C106.802 106.208 106.959 106.558 106.59 106.829C106.418 106.957 106.142 106.989 105.918 106.978C105.805 106.971 105.591 106.716 105.614 106.667C105.705 106.483 105.874 106.336 106.042 106.139Z" fill="$color"/>
      <path d="M36.9998 100.64C33.7632 97.5297 33.1862 93.5951 36.1825 89.8371C36.1955 89.8208 36.207 89.8012 36.2233 89.7913C36.4211 89.6769 36.6189 89.5641 36.8167 89.4497C36.8625 89.556 36.9753 89.7047 36.9393 89.7619C36.833 89.9336 36.6696 90.0709 36.408 90.3504C36.2805 90.8244 36.6238 91.3246 36.9524 91.8118C37.4542 92.5539 38.01 93.26 38.5069 94.0038C40.2511 96.6127 39.7574 98.7982 36.9998 100.64Z" fill="$color"/>
      <path d="M102.313 100.686C100.831 99.591 99.5803 98.3944 99.8156 96.3576C99.9595 95.1153 100.697 94.1411 101.38 93.1505C101.808 92.531 102.261 91.9261 102.64 91.2772C102.823 90.9633 102.859 90.5645 102.984 90.1346C102.361 90.1346 102.248 89.8943 102.531 89.3091C103.721 90.3389 104.416 91.5992 104.808 92.9936C105.676 96.0732 104.412 98.5056 102.313 100.686Z" fill="$color"/>
      <path d="M36.9475 101.757C32.9508 102.833 29.5785 101.842 26.8879 98.6446C26.597 98.2981 26.3681 98.2131 26.1572 98.4681C26.1899 98.8195 26.2128 99.0533 26.2357 99.287C25.9791 99.2641 25.6685 99.323 25.4772 99.1988C25.1618 98.9944 25.2222 98.6577 25.4789 98.4125C26.4417 97.4955 27.5859 96.956 28.9181 96.8743C31.2066 96.7337 33.0652 97.7505 34.7195 99.1791C35.5597 99.9033 36.2822 100.765 37.0586 101.564C37.0227 101.629 36.9851 101.693 36.9475 101.757Z" fill="$color"/>
      <path d="M102.251 101.7C103.587 99.9112 105.089 98.4793 107.029 97.5573C108.329 96.9395 109.717 96.5896 111.121 97.0032C112.017 97.2664 112.844 97.7878 113.666 98.257C113.98 98.4351 114.246 98.8291 113.854 99.1642C113.677 99.3146 113.321 99.2541 113.046 99.2884C113.068 99.0645 113.087 98.8422 113.109 98.6182C112.919 98.1262 112.648 98.3649 112.366 98.7032C111.026 100.315 109.377 101.462 107.315 101.943C105.651 102.33 103.997 102.255 102.251 101.7Z" fill="$color"/>
      <path d="M123.475 75.8135C122.947 75.3901 122.933 75.8822 122.867 76.2451C122.552 77.9827 121.798 79.4833 120.466 80.6586C119.184 81.7881 117.672 82.3455 115.878 82.4175C116.304 79.8249 116.974 77.4302 119.129 75.7743C120.571 74.666 122.182 74.7052 123.824 75.2643C123.989 75.3199 124.209 75.4343 124.255 75.57C124.325 75.7857 124.327 76.0653 124.244 76.2745C124.203 76.3758 123.822 76.469 123.745 76.4004C123.598 76.268 123.559 76.0162 123.475 75.8135Z" fill="$color"/>
      <path d="M15.823 75.8137C15.738 76.0164 15.7005 76.2861 15.5484 76.3973C15.4536 76.4676 15.0401 76.327 15.0221 76.2338C14.9763 75.9952 14.9976 75.5603 15.1251 75.5031C15.6923 75.253 16.2938 75.0127 16.9035 74.9425C19.1593 74.6826 20.7155 75.7876 21.8451 77.6363C22.7278 79.0814 23.1822 80.6686 23.4061 82.3915C22.1965 82.4324 21.1225 82.0875 20.114 81.5415C18.0102 80.4038 16.897 78.5566 16.436 76.2665C16.3559 75.8726 16.3396 75.4312 15.823 75.8137Z" fill="$color"/>
      <path d="M28.9639 71.0371C28.771 71.3036 28.5847 71.6583 28.5193 71.637C28.0125 71.4768 27.957 71.892 27.9537 72.134C27.9422 73.1049 27.9749 74.0775 28.0354 75.0452C28.1139 76.2876 28.2463 77.5315 27.7134 78.7166C27.0857 80.1126 25.4739 81.2471 23.8213 81.4301C23.138 79.091 23.2443 76.8352 24.4703 74.6725C25.3579 73.1098 27.7559 71.0878 28.9639 71.0371Z" fill="$color"/>
      <path d="M110.552 70.9961C112.294 71.7987 113.772 72.9103 114.771 74.5825C116.074 76.7647 116.16 79.0712 115.482 81.4627C112.862 80.8857 111.065 79.3262 111.201 76.4182C111.258 75.1987 111.391 73.9826 111.448 72.7631C111.462 72.4542 111.338 72.1305 111.237 71.8281C111.206 71.735 111.033 71.6205 110.934 71.6287C110.415 71.6745 110.485 71.3541 110.552 70.9961Z" fill="$color"/>
      <path d="M112.229 88.214C109.447 87.2332 108.237 85.2912 108.937 82.6693C109.22 81.6084 109.594 80.5704 109.844 79.5014C109.962 78.9995 110.241 78.3162 109.319 78.143C109.244 78.1283 109.221 77.8406 109.174 77.6804C109.323 77.6836 109.524 77.6264 109.612 77.7016C110.245 78.2443 110.913 78.7625 111.462 79.382C113.669 81.8732 113.947 85.1866 112.229 88.214Z" fill="$color"/>
      <path d="M26.8013 89.2094C23.2116 89.6213 20.1467 87.7415 18.6493 84.2646C18.4924 83.9001 18.3682 83.5307 18.0298 83.8036C17.9252 84.1878 17.8631 84.4199 17.7993 84.6504C17.5934 84.5736 17.322 84.5523 17.1962 84.4068C16.9379 84.1093 17.1063 83.8069 17.3956 83.6385C18.8455 82.7918 20.3788 82.5858 21.9644 83.1923C23.4078 83.7448 24.4294 84.8171 25.286 86.0611C25.9415 87.0173 26.4858 88.0324 26.8013 89.2094Z" fill="$color"/>
      <path d="M112.471 89.1114C113.471 86.594 114.727 84.2647 117.426 83.1646C118.936 82.5483 120.424 82.8278 121.828 83.5945C122.142 83.7661 122.375 84.0407 122.114 84.3807C121.993 84.5393 121.692 84.5589 121.471 84.6407C121.416 84.4396 121.36 84.2385 121.305 84.0358C121.066 83.5912 120.868 83.7416 120.683 84.1862C119.709 86.5319 118.104 88.2483 115.608 88.9332C114.624 89.2029 113.573 89.2307 112.553 89.368C112.525 89.2847 112.499 89.198 112.471 89.1114Z" fill="$color"/>
      <path d="M30.2046 77.7246C30.1196 77.888 30.0379 78.1888 29.9463 78.1921C29.1486 78.2166 29.3415 78.8116 29.4216 79.1958C29.6047 80.067 29.8924 80.917 30.1392 81.7752C30.4498 82.8573 30.7228 83.9427 30.4253 85.0788C29.9986 86.7036 28.7498 87.5128 27.344 88.147C27.2492 88.1895 26.9729 88.0375 26.9075 87.91C25.3693 84.9121 25.6456 81.4614 28.261 78.9391C28.5994 78.6138 28.9263 78.2755 29.2892 77.978C29.5082 77.7981 29.7812 77.6854 30.0313 77.5415C30.0885 77.602 30.1458 77.6641 30.2046 77.7246Z" fill="$color"/>
      <path d="M106.472 84.0259C109.991 86.3013 111.122 90.9077 108.18 94.6625C107.742 94.378 107.278 94.1198 106.861 93.7994C105.262 92.5685 104.796 91.1137 105.462 89.2109C105.825 88.1762 106.331 87.1938 106.747 86.1771C106.876 85.8616 106.967 85.5101 106.974 85.1734C106.977 84.9985 107.072 84.6062 106.598 84.6454C106.505 84.6536 106.382 84.3103 106.274 84.1305C106.341 84.0962 106.407 84.0602 106.472 84.0259Z" fill="$color"/>
      <path d="M31.1216 94.679C28.0093 90.5744 29.6112 86.0399 33.0064 84.0947C32.9164 84.2827 32.8331 84.6293 32.7366 84.6325C32.1841 84.6505 32.2855 85.0641 32.3411 85.324C32.4489 85.8356 32.6386 86.3342 32.8331 86.8229C33.178 87.6909 33.6144 88.5262 33.9021 89.4122C34.4661 91.1466 33.9953 92.585 32.565 93.695C32.104 94.0529 31.6006 94.3553 31.1216 94.679Z" fill="$color"/>
      <path d="M30.9206 95.586C27.2884 96.2415 23.9717 94.6477 22.2096 91.4503C22.0281 91.1218 21.8827 90.7458 21.5378 90.9796C21.4544 91.349 21.4004 91.586 21.3465 91.823C21.1291 91.7528 20.8316 91.7495 20.7123 91.6007C20.4573 91.2836 20.6322 90.9812 20.9444 90.7867C22.2439 89.9775 23.6595 89.5967 25.147 90.0331C28.0093 90.87 29.6096 93.0605 30.9206 95.586Z" fill="$color"/>
      <path d="M117.842 91.032C117.548 90.7606 117.36 90.965 117.175 91.3082C116.455 92.6405 115.489 93.7569 114.187 94.5497C112.412 95.6318 110.498 95.9898 108.363 95.6008C109.807 92.9298 111.459 90.5808 114.643 89.9466C115.964 89.6834 117.18 90.0773 118.312 90.7574C118.431 90.8293 118.604 90.9502 118.604 91.05C118.606 91.2837 118.58 91.5698 118.444 91.7316C118.356 91.8362 118.052 91.7578 117.844 91.761C117.842 91.5583 117.842 91.3556 117.842 91.032Z" fill="$color"/>
      <path d="M21.4299 60.4039C20.1696 59.8301 19.3866 58.9098 18.9109 57.7149C18.3012 56.1767 18.4957 54.6336 18.9354 53.0954C18.9697 52.9777 19.0384 52.86 19.0319 52.7456C19.0269 52.6492 18.9387 52.556 18.888 52.4612C18.7867 52.5168 18.6771 52.5609 18.5872 52.6312C18.4499 52.7374 18.3371 52.8829 18.19 52.9663C18.1524 52.9875 17.9399 52.8355 17.9448 52.7767C17.9628 52.5871 17.989 52.3255 18.1148 52.2372C18.3142 52.0983 18.6003 52.0051 18.8422 52.0166C20.5243 52.0983 21.662 52.963 22.0935 54.5699C22.633 56.5707 22.1001 58.4669 21.4299 60.4039Z" fill="$color"/>
      <path d="M117.887 60.4185C117.216 58.5958 116.801 56.8321 117.104 54.962C117.385 53.2162 118.777 52.0132 120.538 52.0001C120.929 51.9968 121.292 52.0949 121.363 52.546C121.383 52.6735 121.249 52.8795 121.126 52.9547C121.058 52.9972 120.858 52.8615 120.739 52.7782C120.613 52.6899 120.51 52.5673 120.399 52.461C120.37 52.636 120.272 52.8321 120.321 52.9809C120.726 54.2412 120.927 55.5145 120.649 56.8304C120.309 58.4324 119.439 59.6338 117.887 60.4185Z" fill="$color"/>
      <path d="M109.166 53.0462C112.361 52.7307 116.427 55.4049 117.125 59.7482C115.032 60.2157 113.107 59.3117 112.088 57.3305C111.595 56.3726 111.191 55.3673 110.732 54.3915C110.603 54.1168 110.454 53.8341 110.243 53.6232C110.109 53.4875 109.846 53.4826 109.643 53.4123C109.462 53.3502 109.283 53.2783 109.104 53.2096C109.123 53.1557 109.145 53.1001 109.166 53.0462Z" fill="$color"/>
      <path d="M30.1981 53.1247C30.0706 53.2277 29.9104 53.4418 29.8188 53.4157C29.0146 53.1852 28.8495 53.8521 28.6174 54.3066C28.1172 55.2824 27.7232 56.3123 27.2328 57.293C26.6133 58.5337 25.6685 59.441 24.2725 59.7205C23.6056 59.8545 22.9076 59.8267 22.2079 59.8741C22.6231 56.1766 26.0968 52.8599 30.1981 53.1247Z" fill="$color"/>
      <path d="M21.067 67.5485C19.0776 67.1088 17.5476 65.4578 17.201 63.2821C17.0784 62.5073 17.1504 61.7014 17.1128 60.9119C17.1062 60.7599 17.0049 60.6128 16.946 60.464C16.8561 60.5768 16.7809 60.7076 16.6731 60.7991C16.5374 60.9103 16.3739 60.9904 16.2235 61.0835C16.1434 60.9184 15.9555 60.6585 16.0029 60.603C16.1859 60.3921 16.4279 60.1354 16.6796 60.0962C18.6297 59.7824 20.0192 60.567 20.7547 62.3978C21.3972 63.9948 21.3841 65.6589 21.1569 67.3328C21.1454 67.408 21.0964 67.4782 21.067 67.5485Z" fill="$color"/>
      <path d="M118.169 67.6058C118.112 67.0042 118.024 66.4631 118.017 65.9221C117.996 64.2319 118.128 62.5678 119.258 61.1816C120.177 60.0537 121.426 59.9001 122.758 60.1126C122.96 60.1453 123.199 60.3594 123.289 60.5507C123.343 60.6667 123.144 60.9021 123.059 61.0836C122.913 60.9838 122.758 60.8972 122.627 60.7828C122.524 60.6929 122.452 60.5686 122.367 60.4591C122.302 60.6062 122.191 60.7501 122.179 60.9021C122.104 61.8911 122.194 62.9176 121.958 63.8641C121.479 65.7897 120.17 66.9993 118.169 67.6058Z" fill="$color"/>
      <path d="M117.618 66.774C115.59 66.9571 113.838 65.7802 113.208 63.7581C112.871 62.6743 112.701 61.5399 112.437 60.4333C112.371 60.1603 112.268 59.8775 112.11 59.6519C112.007 59.5048 111.768 59.4541 111.593 59.3544C111.436 59.2645 111.283 59.1664 111.189 58.9604C112.574 59.1141 113.785 59.6633 114.83 60.5444C116.739 62.1578 117.596 64.2583 117.618 66.774Z" fill="$color"/>
      <path d="M21.7535 66.81C21.3367 63.2121 24.9525 58.7218 28.2005 58.9277C28.0632 59.1043 27.9602 59.3348 27.8752 59.3282C27.0874 59.2726 27.0073 59.8987 26.8781 60.394C26.6035 61.4532 26.4417 62.5436 26.154 63.6012C25.6031 65.6297 23.9129 66.8443 21.7535 66.81Z" fill="$color"/>
      <path d="M112.067 65.2588C113.282 65.7279 114.352 66.4423 115.225 67.4361C116.863 69.2996 117.275 71.4835 116.84 73.8766C114.504 73.6788 112.991 71.9821 112.937 69.5187C112.917 68.6425 112.974 67.7614 112.919 66.8885C112.889 66.4243 112.991 65.7737 112.169 65.7835C112.085 65.7851 112 65.5612 111.915 65.4419C111.966 65.3798 112.017 65.3193 112.067 65.2588Z" fill="$color"/>
      <path d="M22.0756 74.7084C19.9767 74.4502 18.4189 73.525 17.5427 71.6942C17.1651 70.9063 17.0262 70.0007 16.8071 69.1409C16.7287 68.8303 16.7483 68.4756 16.3609 68.7665C16.2399 68.9513 16.1336 69.1458 15.9849 69.3043C15.9653 69.3256 15.6204 69.1196 15.6318 69.0837C15.707 68.8434 15.7822 68.4936 15.962 68.4135C17.206 67.861 18.8373 67.928 19.9947 69.0363C21.2517 70.2393 21.6963 71.8135 21.9546 73.4629C22.0134 73.8388 22.0281 74.2213 22.0756 74.7084Z" fill="$color"/>
      <path d="M27.3832 65.4714C27.2868 65.5841 27.1854 65.7983 27.0939 65.795C26.3174 65.764 26.4204 66.3949 26.3893 66.8052C26.3256 67.6569 26.3746 68.5151 26.3681 69.3716C26.3468 71.9429 25.0882 73.4141 22.4695 73.9028C22.0527 71.6993 22.3551 69.638 23.7445 67.835C24.6566 66.6516 25.8238 65.7738 27.2361 65.2817C27.2851 65.3455 27.3342 65.4076 27.3832 65.4714Z" fill="$color"/>
      <path d="M122.913 68.6439C122.459 68.4461 122.532 68.9055 122.498 69.2291C122.294 71.176 121.506 72.7877 119.814 73.8666C119.054 74.3504 118.215 74.6251 117.229 74.6823C117.419 72.4101 117.77 70.2704 119.639 68.7812C120.736 67.9067 122.011 67.9214 123.299 68.3562C123.356 68.3758 123.435 68.402 123.454 68.4478C123.544 68.6521 123.654 68.8613 123.672 69.0771C123.676 69.1392 123.302 69.3174 123.273 69.2847C123.137 69.1376 123.065 68.9349 122.913 68.6439Z" fill="$color"/>
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
