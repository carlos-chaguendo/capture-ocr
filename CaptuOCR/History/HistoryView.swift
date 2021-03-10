//
//  HistoryView.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 5/03/21.
//

import SwiftUI

struct HistoryView: View {
    
    private let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        return df
    }()
    
    @State var records: [HistoryRecord]!
    
    var body: some View {
        NavigationView {
            List(records) { record in
                
                NavigationLink(destination: HistoryRecordView(record: record, df: df, delegate: self)) {
                    /// Item
                    VStack(alignment: .leading, spacing: 0) {
                        Text(df.string(from: record.date))
            
//                        Text(record.text)
//                            .font(.caption2)
                        Divider()
                    }
                }
                
            }.frame(width: 180  , height: nil)
            
            
        }.frame(width: 600  , height: 600)
        .navigationTitle("Landmarks")

    }
}

extension HistoryView: HistoryRecordViewDelegate {
    
    func historyRecordView(didRemove record: HistoryRecord) {
        guard let i = records.firstIndex(of: record) else { return }
        records.remove(at: i)
    }
    
}

struct HistoryView_Previews: PreviewProvider {
  
    static var previews: some View {
        HistoryView(records: [HistoryRecord()])
    }
}


