const LOCAL_STORAGE = window.localStorage;
const DEFAULT_COOKIE_TTL = 10368000000;   // 120 days in ms
// The UTM parameters you want to track
const UTM_CAMPAIGN = 'utm_campaign';
const UTM_MEDIUM = 'utm_medium';
const UTM_SOURCE = 'utm_source';
export const UTM_PARAMS = [
  UTM_CAMPAIGN,
  UTM_MEDIUM,
  UTM_SOURCE
];

export class UtmTrackingService {
  /**
   * Private helper function to handle
   * setting the new UTM parameter's value
   * @param {String} utmParam
   * @param {String} utmValue
   */
  private setNewUTMCookie(utmParam, utmValue) {
    if (utmParam && utmValue) {
      const now = new Date();
      const utmCookie = {
        value: [utmValue],
        expiry: now.getTime() + DEFAULT_COOKIE_TTL
      };
      LOCAL_STORAGE.setItem(
        utmParam,
        JSON.stringify(utmCookie)
      );
    }
    return true;
  }

  /**
   * Private helper function to handle appending
   * a UTM value to an existing UTM parameter's cookie
   * @param {String} utmParam
   * @param {String} utmValue
   * @param {Object} utmCookie
   */
  private setExistingUTMCookie(utmParam, utmValue, utmCookie) {
    if (utmParam && utmValue && utmCookie) {
      if (!utmCookie.value.includes(utmValue)) {
        const now = new Date();
        utmCookie.value.push(utmValue);
        utmCookie.expiry = now.getTime() + DEFAULT_COOKIE_TTL;
        LOCAL_STORAGE.setItem(
          utmParam,
          JSON.stringify(utmCookie)
        );
      }
    }
    return true;
  }

  /**
   * Entry function to handle how
   * to store the UTM parameter found in the URL
   * @param utmParam
   * @param utmValue
   */
  private storeUTMParam(utmParam, utmValue) {
    if (utmParam && utmValue) {
      const rawUTMCookie = LOCAL_STORAGE.getItem(utmParam);
      // If no cookie exists, create a new one with expiration for 120 days
      if (!rawUTMCookie) {
        this.setNewUTMCookie(utmParam, utmValue);
      } else {
        const utmCookie = JSON.parse(rawUTMCookie);
        const now = new Date();
        // If cookie has expired, remove it and set a new one with default expiration
        if (now.getTime() > utmCookie.expiry) {
          LOCAL_STORAGE.removeItem(utmParam);
          this.setNewUTMCookie(utmParam, utmValue);
        } else {
          // Cookie has not expire and exists, so append the new utm value
          this.setExistingUTMCookie(utmParam, utmValue, utmCookie);
        }
      }
    }
  }

  /**
   * Search the array of parameters for the specified UTM parameter
   * @param {String} utmParam
   * @param {Array} urlParams
   */
  private getUTMParamFromURL(utmParam, urlParams = []) {
    if (utmParam) {
      for (let i = 0; i < urlParams.length; i++) {
        const param = urlParams[i];
        const keyValue = param.split('=');
        if (keyValue[0] === utmParam && keyValue[1]) {
          return decodeURIComponent(keyValue[1]);
        }
      }
    }
  }

  /**
   * Trigger to check the current URL for the UTM params
   */
  public checkForUTMParams() {
    const URLParams = window.location.search.substr(1).split('&');
    UTM_PARAMS.forEach((utmParam) => {
      const utmValue = this.getUTMParamFromURL(utmParam, URLParams);
      if (utmValue) {
        this.storeUTMParam(utmParam, utmValue);
      }
    });
  }

  /**
   * If the given parameter is valid, attempt to
   * retrieve the UTM value from local storage
   * (If the cookie has expired, delete it and return null)
   * @param {String} param
   */
  public getUTMParamFromCookie(param) {
    if (param && UTM_PARAMS.includes(param)) {
      const rawUTMCookie = LOCAL_STORAGE.getItem(param);
      if (!rawUTMCookie) {
        return null;
      } else {
        const now = new Date();
        const utmCookie = JSON.parse(rawUTMCookie);
        // If the cookie is expired, delete it and return null
        if (now.getTime() > utmCookie.expiry) {
          LOCAL_STORAGE.removeItem(param);
          return null;
        } else {
          return utmCookie.value;
        }
      }
    } else {
      return null;
    }
  }
}