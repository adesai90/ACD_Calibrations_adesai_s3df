// In AcdCalibBase.cpp, replace the go() function:

void AcdCalibBase::go(int numEvents, int startEvent) {

  int nTotal = getTotalEvents();
  // ---AD changed: Handle case where getTotalEvents() returns -1 or 0
  if ( nTotal <= 0 ) { // ---AD changed
    std::cout << "WARNING: No events found in chain, attempting to use all available entries" << std::endl; // ---AD changed
    TChain* chain = getChain(AcdCalib::DIGI); // ---AD changed: get first non-null chain
    if (chain == 0) { // ---AD changed
      for (int i = 0; i < AcdCalib::NCHAIN; i++) { // ---AD changed
        chain = getChain((AcdCalib::CHAIN)i); // ---AD changed
        if (chain != 0) break; // ---AD changed
      } // ---AD changed
    } // ---AD changed
    if (chain != 0) { // ---AD changed
      nTotal = (int)chain->GetEntries(); // ---AD changed
      std::cout << "Found chain with " << nTotal << " entries" << std::endl; // ---AD changed
    } // ---AD changed
  } // ---AD changed
  
  int last = numEvents < 1 ? nTotal : TMath::Min(numEvents+startEvent,nTotal);
  m_eventStats.setRange(startEvent,last);

  cout << "Number of events in the chain: " << nTotal << endl;
  cout << "Number of events used: " << last-startEvent << endl;
  cout << "Starting at event: " << startEvent << endl;
  
  for (Int_t ievent= startEvent; ievent < last; ievent++ ) {
    
    Bool_t filtered(kFALSE);
    Int_t runId, evtId;
    Double_t timeStamp;
    Bool_t ok = readEvent(ievent,filtered, runId, evtId,timeStamp);

    if ( !ok ) {
      cout << "Failed to read event " << ievent << " aborting" << endl;
      break;
    }

    Bool_t used(kFALSE);
    if ( !filtered ) {
      useEvent(used);
    }
    
    m_eventStats.logEvent(ievent,used,filtered,runId,evtId,timeStamp);
  }

  m_eventStats.lastEvent();

  cout << endl;

}