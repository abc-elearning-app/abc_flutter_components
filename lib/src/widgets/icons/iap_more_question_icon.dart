import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/index.dart';

class IAPMoreQuestionIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const IAPMoreQuestionIcon(
      {super.key, this.color, this.height, this.width = 120});

  String getIconContent(String color) {
    return '''
      <svg width="140" height="135" viewBox="0 0 140 135" fill="none" xmlns="http://www.w3.org/2000/svg">
      <g clip-path="url(#clip0_127:5852)">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M78.6721 9.38164C87.4128 8.41683 94.9491 12.3985 98.6928 20.2715C108.23 40.3013 111.933 31.5431 123.621 42.4934C141.759 59.4972 112.859 69.1399 121.71 88.8982C127.135 101.005 119.28 124.765 101.151 118.29C80.4839 110.899 77.6966 122.141 60.4135 121.829C40.3339 121.477 39.0294 107.621 34.2903 99.0543C29.2627 89.9647 12.2887 89.5118 10.5366 74.6503C9.15254 62.8652 23.3194 61.2968 18.262 35.9876C15.4548 21.9103 29.9995 8.04499 43.6384 11.8851C64.8335 17.8484 64.8534 10.9103 78.6721 9.38164Z" fill="$color" fill-opacity="0.1" />
      <path d="M8.45946 38.2526C8.46941 39.5495 9.00728 40.7163 9.85349 41.5709C10.7097 42.4454 11.894 42.9787 13.1978 42.9787C13.9744 42.9787 14.6018 43.6122 14.6018 44.3965C14.6018 45.1807 13.9744 45.8242 13.1978 45.8242C11.8933 45.8242 10.7089 46.3574 9.85349 47.232C8.98739 48.0965 8.45946 49.2932 8.45946 50.6107C8.45946 51.3949 7.83207 52.0284 7.05548 52.0284C6.27889 52.0284 5.64232 51.3942 5.64232 50.6107C5.64232 49.2932 5.11439 48.0965 4.24828 47.232C3.39212 46.3574 2.20697 45.8242 0.903215 45.8242C0.127392 45.8242 -0.5 45.1807 -0.5 44.3965C-0.5 43.6122 0.127392 42.9787 0.903215 42.9787C2.20773 42.9787 3.39212 42.4454 4.24828 41.5709C5.0945 40.7163 5.63161 39.5495 5.64232 38.2526C5.64232 38.2327 5.64232 38.2121 5.64232 38.1922C5.64232 37.4079 6.27889 36.7744 7.05548 36.7744C7.83207 36.7744 8.45946 37.4079 8.45946 38.1922C8.45946 38.2121 8.45946 38.2327 8.45946 38.2526Z" fill="$color" fill-opacity="0.1" />
      <path d="M115.239 7.25569C115.248 8.15087 115.617 8.97566 116.204 9.56862C116.812 10.1715 117.638 10.5533 118.544 10.5533C119.082 10.5533 119.519 10.9956 119.519 11.5388C119.519 12.082 119.082 12.5235 118.544 12.5235C117.638 12.5235 116.812 12.906 116.204 13.5089C115.607 14.1126 115.239 14.9573 115.239 15.8724C115.239 16.4148 114.801 16.8571 114.253 16.8571C113.715 16.8571 113.278 16.4141 113.278 15.8724C113.278 14.9573 112.899 14.1126 112.302 13.5089C111.705 12.9053 110.878 12.5235 109.962 12.5235C109.425 12.5235 108.987 12.0812 108.987 11.5388C108.987 10.9956 109.425 10.5533 109.962 10.5533C110.878 10.5533 111.704 10.1708 112.302 9.56862C112.89 8.97566 113.268 8.15087 113.278 7.25569C113.278 7.2358 113.278 7.22508 113.278 7.20519C113.278 6.66196 113.715 6.21973 114.253 6.21973C114.801 6.21973 115.239 6.66196 115.239 7.20519C115.239 7.22508 115.239 7.2358 115.239 7.25569Z" fill="$color" fill-opacity="0.1" />
      <path d="M20.9895 95.6802C20.9995 96.5853 21.3683 97.4002 21.9551 98.0031C22.5626 98.606 23.3889 98.9778 24.2948 98.9778C24.8327 98.9778 25.2703 99.4201 25.2703 99.9733C25.2703 100.516 24.8327 100.959 24.2948 100.959C23.3889 100.959 22.5626 101.341 21.9551 101.944C21.3575 102.547 20.9895 103.383 20.9895 104.297C20.9895 104.85 20.5519 105.292 20.0041 105.292C19.4662 105.292 19.0278 104.85 19.0278 104.297C19.0278 103.383 18.6498 102.547 18.0523 101.944C17.4547 101.341 16.6284 100.959 15.7233 100.959C15.1754 100.959 14.7378 100.516 14.7378 99.9733C14.7378 99.4201 15.1762 98.9778 15.7233 98.9778C16.6291 98.9778 17.4547 98.606 18.0523 98.0031C18.6399 97.3994 19.0178 96.5853 19.0278 95.6802C19.0278 95.6703 19.0278 95.6504 19.0278 95.6404C19.0278 95.0972 19.4662 94.645 20.0041 94.645C20.5519 94.645 20.9895 95.0972 20.9895 95.6404C20.9895 95.6504 20.9895 95.6703 20.9895 95.6802Z" fill="$color"/>
      <path d="M91.5283 122.925C91.5482 124.011 91.9866 124.987 92.6935 125.7C93.4204 126.435 94.4059 126.887 95.5007 126.887C96.148 126.887 96.6759 127.41 96.6759 128.074C96.6759 128.727 96.1488 129.261 95.5007 129.261C94.4059 129.261 93.4196 129.713 92.6935 130.437C91.9774 131.161 91.5283 132.167 91.5283 133.263C91.5283 133.926 91.0003 134.459 90.3538 134.459C89.7065 134.459 89.1794 133.927 89.1794 133.263C89.1794 132.167 88.731 131.161 88.0149 130.437C87.288 129.713 86.3026 129.261 85.2069 129.261C84.5604 129.261 84.0325 128.728 84.0325 128.074C84.0325 127.411 84.5604 126.887 85.2069 126.887C86.3018 126.887 87.288 126.435 88.0149 125.7C88.7218 124.987 89.1595 124.011 89.1794 122.925C89.1794 122.905 89.1794 122.895 89.1794 122.875C89.1794 122.222 89.7065 121.688 90.3538 121.688C91.0011 121.688 91.5283 122.222 91.5283 122.875C91.5283 122.896 91.5283 122.906 91.5283 122.925Z" fill="$color" fill-opacity="0.1" />
      <path d="M135.977 78.2059C135.997 79.3627 136.466 80.4079 137.222 81.1722C137.989 81.9465 139.044 82.4186 140.209 82.4186C140.906 82.4186 141.463 82.9917 141.463 83.6856C141.463 84.3895 140.906 84.9526 140.209 84.9526C139.045 84.9526 137.989 85.4354 137.222 86.2097C136.456 86.984 135.977 88.0598 135.977 89.2266C135.977 89.9305 135.42 90.4936 134.723 90.4936C134.036 90.4936 133.469 89.9305 133.469 89.2266C133.469 88.0598 132.991 86.984 132.225 86.2097C131.458 85.4354 130.403 84.9526 129.238 84.9526C128.551 84.9526 127.984 84.3895 127.984 83.6856C127.984 82.9917 128.551 82.4186 129.238 82.4186C130.403 82.4186 131.459 81.9458 132.225 81.1722C132.981 80.4079 133.46 79.362 133.469 78.2059C133.469 78.186 133.469 78.1661 133.469 78.1454C133.469 77.4515 134.026 76.8784 134.723 76.8784C135.42 76.8784 135.977 77.4515 135.977 78.1454C135.977 78.1653 135.977 78.1852 135.977 78.2059Z" fill="$color"/>
      <path d="M53.4349 0.905127C53.4449 1.67942 53.7632 2.39327 54.2811 2.91661C54.7991 3.43918 55.516 3.76052 56.3018 3.76052C56.78 3.76052 57.158 4.15303 57.158 4.62587C57.158 5.0987 56.78 5.4805 56.3018 5.4805C55.516 5.4805 54.7991 5.81179 54.2811 6.33513C53.7532 6.86764 53.4349 7.5922 53.4349 8.38639C53.4349 8.85923 53.057 9.25173 52.5788 9.25173C52.1105 9.25173 51.7333 8.85923 51.7333 8.38639C51.7333 7.5922 51.4051 6.86841 50.8871 6.33513C50.3691 5.81255 49.643 5.4805 48.8557 5.4805C48.3875 5.4805 48.0095 5.09794 48.0095 4.62587C48.0095 4.15303 48.3875 3.76052 48.8557 3.76052C49.6423 3.76052 50.3691 3.43918 50.8871 2.91661C51.3951 2.39327 51.7234 1.68019 51.7333 0.905127C51.7333 0.885234 51.7333 0.875288 51.7333 0.864576C51.7333 0.381791 52.1113 0 52.5788 0C53.057 0 53.4349 0.381791 53.4349 0.864576C53.4349 0.875288 53.4349 0.885234 53.4349 0.905127Z" fill="$color"/>
      <path d="M94.5521 41.7268C87.7464 34.9219 78.699 31.1736 69.0747 31.1736C59.4503 31.1736 50.4029 34.9211 43.5972 41.7268C29.549 55.775 29.549 78.6335 43.5972 92.6809C50.4021 99.4858 59.4503 103.233 69.0747 103.233C78.699 103.233 87.7464 99.4858 94.5521 92.6809C108.6 78.6335 108.6 55.775 94.5521 41.7268ZM88.8972 87.0267C83.6026 92.3213 76.5628 95.2372 69.0747 95.2372C61.5865 95.2372 54.5475 92.3213 49.2521 87.0267C43.9576 81.7322 41.0417 74.6924 41.0417 67.2042C41.0417 59.7161 43.9576 52.6771 49.2521 47.3817C54.5475 42.0871 61.5865 39.1713 69.0747 39.1713C76.5628 39.1713 83.6018 42.0871 88.8972 47.3817C94.1917 52.6771 97.1076 59.7161 97.1076 67.2042C97.1076 74.6924 94.1917 81.7314 88.8972 87.0267Z" fill="$color"/>
      <circle cx="69.5" cy="67" r="33" fill="$color"/>
      <path d="M52.304 67.3C52.304 66.3027 52.744 65.804 53.624 65.804C54.1227 65.804 54.4747 65.8993 54.68 66.09C54.9147 66.2953 55.0393 66.6033 55.054 67.014V69.544L56.286 69.522C57.1367 69.522 57.562 69.9547 57.562 70.82C57.562 71.832 57.1587 72.338 56.352 72.338H55.076C55.076 72.6607 55.076 72.9613 55.076 73.24C55.076 73.504 55.0687 73.7533 55.054 73.988C55.0247 74.824 54.5627 75.242 53.668 75.242C52.744 75.2713 52.282 74.8533 52.282 73.988V72.272H49.686H47.112C46.6427 72.272 46.276 72.096 46.012 71.744C45.748 71.392 45.616 71.0033 45.616 70.578C45.616 69.9033 45.814 69.2433 46.21 68.598C46.6207 67.894 47.178 66.904 47.882 65.628C48.586 64.352 49.444 62.768 50.456 60.876C50.7787 60.26 51.2553 59.952 51.886 59.952C52.282 59.952 52.656 60.084 53.008 60.348C53.36 60.612 53.536 60.9053 53.536 61.228C53.536 61.5213 53.4627 61.7853 53.316 62.02C53.14 62.3573 52.92 62.7607 52.656 63.23C52.392 63.6847 52.0913 64.198 51.754 64.77C51.4167 65.342 51.138 65.8187 50.918 66.2C50.698 66.5667 50.5367 66.8307 50.434 66.992L49.048 69.5L52.282 69.456L52.304 67.168V67.3ZM59.2337 68.092C59.2337 65.7013 59.7543 63.7433 60.7957 62.218C61.837 60.6927 63.311 59.93 65.2177 59.93C67.0657 59.93 68.5177 60.6193 69.5737 61.998C70.6297 63.3913 71.1577 65.2687 71.1577 67.63C71.1577 69.9767 70.5857 71.81 69.4417 73.13C68.2977 74.45 66.8823 75.11 65.1957 75.11C63.5237 75.11 62.1157 74.4793 60.9717 73.218C59.8277 71.9713 59.2557 70.2627 59.2557 68.092H59.2337ZM65.1737 62.724C63.1643 62.724 62.1597 64.4767 62.1597 67.982C62.1597 69.2433 62.4237 70.292 62.9517 71.128C63.4797 71.964 64.1837 72.382 65.0637 72.382C66.0023 72.382 66.7503 71.964 67.3077 71.128C67.865 70.2773 68.1437 69.1407 68.1437 67.718C68.1437 66.2513 67.8943 65.0487 67.3957 64.11C66.8823 63.1567 66.1563 62.68 65.2177 62.68L65.1737 62.724ZM73.4881 68.092C73.4881 65.7013 74.0088 63.7433 75.0501 62.218C76.0914 60.6927 77.5654 59.93 79.4721 59.93C81.3201 59.93 82.7721 60.6193 83.8281 61.998C84.8841 63.3913 85.4121 65.2687 85.4121 67.63C85.4121 69.9767 84.8401 71.81 83.6961 73.13C82.5521 74.45 81.1368 75.11 79.4501 75.11C77.7781 75.11 76.3701 74.4793 75.2261 73.218C74.0821 71.9713 73.5101 70.2627 73.5101 68.092H73.4881ZM79.4281 62.724C77.4188 62.724 76.4141 64.4767 76.4141 67.982C76.4141 69.2433 76.6781 70.292 77.2061 71.128C77.7341 71.964 78.4381 72.382 79.3181 72.382C80.2568 72.382 81.0048 71.964 81.5621 71.128C82.1194 70.2773 82.3981 69.1407 82.3981 67.718C82.3981 66.2513 82.1488 65.0487 81.6501 64.11C81.1368 63.1567 80.4108 62.68 79.4721 62.68L79.4281 62.724ZM88.2926 70.38C87.8672 70.38 87.5592 70.248 87.3686 69.984C87.1779 69.72 87.0899 69.3827 87.1046 68.972C87.1192 68.224 87.5372 67.85 88.3586 67.85H89.7226H91.0646V66.86V65.518V64.682C91.0646 64.286 91.1892 63.978 91.4386 63.758C91.6732 63.538 91.9739 63.428 92.3406 63.428C93.1472 63.428 93.5506 63.846 93.5506 64.682V66.09V67.85C94.0932 67.85 94.5846 67.85 95.0246 67.85C95.4792 67.8353 95.8899 67.8207 96.2566 67.806C97.0486 67.806 97.4446 68.224 97.4446 69.06C97.4446 69.412 97.3419 69.7053 97.1366 69.94C96.9459 70.1453 96.6452 70.2627 96.2346 70.292H93.5066V71.436V72.624V73.416C93.5066 74.164 93.0592 74.538 92.1646 74.538C91.7832 74.5087 91.4972 74.3913 91.3066 74.186C91.1159 73.9807 91.0206 73.6947 91.0206 73.328V70.314H88.2706L88.2926 70.38Z" fill="white"/>
      </g>
      <defs>
      <clipPath id="clip0_127:5852">
      <rect width="140" height="134.964" fill="white"/>
      </clipPath>
      </defs>
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
