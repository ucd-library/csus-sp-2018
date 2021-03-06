import {Element as PolymerElement} from "@polymer/polymer/polymer-element"
import CollectionInterface from "../../interfaces/CollectionInterface"
import ElasticSearchInterface from "../../interfaces/ElasticSearchInterface"
import AppStateInterface from "../../interfaces/AppStateInterface"
import template from "./app-search-breadcrumb.html"


class AppSearchBreadcrumb extends Mixin(PolymerElement)
        .with(EventInterface, AppStateInterface, CollectionInterface, ElasticSearchInterface) {

  static get properties() {
    return {
      collection : {
        type : Object,
        value : null
      },
      record : {
        type : Object,
        value : null
      },
      name : {
        type : String,
        value : ''
      }
    }
  }

  static get template() {
    return template;
  }

  constructor() {
    super();
    this.active = true;
  }

  ready() {
    super.ready();
    this.$.layout.style.width = (window.innerWidth-55)+'px';
    window.addEventListener('resize', () => {
      this.$.layout.style.width = (window.innerWidth-55)+'px';
    });
  }

  /**
   * @method _onAppStateUpdate
   * @description listen to app state update events and if this is a record, set record collection
   * as the current collection
   */
  async _onAppStateUpdate(e) {
    if( e.location.path[0] === 'search' ) {
      this.lastSearch = e.location.pathname;
      return;
    }

    if( e.location.path[0] !== 'record' ) return;

    let path = e.location.path.slice(0);
    path.splice(0, 1);
    this.currentRecordId = '/'+path.join('/');

    this.record = await this._esGetRecord(this.currentRecordId);
    this.record = this.record.payload._source;

    if( this.record.isPartOf ) {
      this.collection = await this._getCollection(this.record.isPartOf);
    } else {
      this.collection = null;
    }
  }

  /**
   * @method _onSearchClicked
   * @description bound to search anchor tag click event.  nav to search
   */
  _onSearchClicked() {
    this._setWindowLocation(this.lastSearch || '/search');
  }

  /**
   * @method _onCollectionClicked
   * @description bound to collection anchor tag click event.  start a collection query
   */
  _onCollectionClicked() {
    this._esClearFilters();
    this._esSetKeywordFilter('isPartOf', this.collection.id);
  }

  /**
   * @method _onSelectedCollectionUpdate
   * @description CollectionInterface, fired when selected collection updates
   */
  _onSelectedCollectionUpdate(e) {
    this.collection = e;
    this.record = null;
  }

}
customElements.define('app-search-breadcrumb', AppSearchBreadcrumb);