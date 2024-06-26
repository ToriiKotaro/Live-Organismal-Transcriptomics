library(Seurat)
IndexS <- read.csv(“/home/torii/2022_IndexSorting_Hiseq015/ForBatchColl_HV_SC_2345.csv”, header = TRUE, row.names=1)
IndexS_N <- NormalizeData(object=IndexS, normalization.method = “LogNormalize”, scale.factor = 10000)
IndexS_s <- CreateSeuratObject(counts = IndexS_N, project = “IndexSort”)
#IndexS_s <- CreateSeuratObject(counts = IndexS, project = “IndexSort”)
LC <- read.csv(“/home/torii/2022_IndexSorting_Hiseq015/ForBatchColl_HV_LC.csv”, header = TRUE, row.names=1)
LC_N <- NormalizeData(object=LC, normalization.method = “LogNormalize”, scale.factor = 10000)
LC_s <- CreateSeuratObject(counts = LC_N, project = “LiveCell”)
#LC_s <- CreateSeuratObject(counts = LC, project = “LiveCell”)
x <- list(LC_s,IndexS_s)
features <- SelectIntegrationFeatures(object.list = x, fvn.nfeatures=2500)
tig.anchors <- FindIntegrationAnchors(object.list = x, anchor.features = features, k.filter = 20)
tig.combined <- IntegrateData(anchorset = tig.anchors, k.weight = 10)
ResB <- as.data.frame(as.matrix(tig.combined@assays$integrated@data))
write.csv(ResB, file = “/home/torii/HeLa_LC_TimeSeries/BatchCollectedHV_w10_f20_2345.csv”)