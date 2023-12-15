-- CreateEnum
CREATE TYPE "OrderStatusType" AS ENUM ('AwaitingProcessing', 'InProcess', 'ReadyToShip', 'Shipped', 'Delivered', 'Canceled', 'Rejection', 'PendingRefund', 'Return', 'Returned', 'PendingPayment');

-- CreateEnum
CREATE TYPE "RefundStatusType" AS ENUM ('Pending', 'Processing', 'TransferredToCard', 'Completed', 'Denied', 'Canceled');

-- CreateEnum
CREATE TYPE "DeliveryMethodType" AS ENUM ('Courier', 'PickupPoint');

-- CreateEnum
CREATE TYPE "ReturnReasonType" AS ENUM ('DidntFit', 'BadQuality', 'WarrantyCase', 'WrongItem', 'OrderError', 'NotAsDescribed');

-- CreateTable
CREATE TABLE "CustomerOrder" (
    "id" TEXT NOT NULL,
    "customerOrderNumber" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "deliveryId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CustomerOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SellerOrder" (
    "id" TEXT NOT NULL,
    "sellerOrderNumber" TEXT NOT NULL,
    "customerOrderId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "status" "OrderStatusType" NOT NULL,

    CONSTRAINT "SellerOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SellerOrderItem" (
    "id" TEXT NOT NULL,
    "sellerOrderId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "status" "OrderStatusType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SellerOrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Delivery" (
    "id" TEXT NOT NULL,
    "deliveryMethod" "DeliveryMethodType" NOT NULL,
    "addressId" TEXT NOT NULL,
    "notes" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Delivery_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Return" (
    "id" TEXT NOT NULL,
    "returnNumber" TEXT NOT NULL,
    "sellerOrderItemId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "deliveryId" TEXT NOT NULL,
    "reason" "ReturnReasonType" NOT NULL,
    "photos" TEXT[],
    "comment" TEXT,
    "refundAmount" DOUBLE PRECISION NOT NULL,
    "refundStatus" "RefundStatusType" NOT NULL,
    "refundNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Return_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SellerOrderStatusChangeLog" (
    "id" TEXT NOT NULL,
    "sellerOrderId" TEXT NOT NULL,
    "previousStatus" "OrderStatusType" NOT NULL,
    "newStatus" "OrderStatusType" NOT NULL,
    "changedBy" TEXT NOT NULL,
    "changedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SellerOrderStatusChangeLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SellerOrderItemStatusChangeLog" (
    "id" TEXT NOT NULL,
    "sellerOrderItemId" TEXT NOT NULL,
    "previousStatus" "OrderStatusType" NOT NULL,
    "newStatus" "OrderStatusType" NOT NULL,
    "changedBy" TEXT NOT NULL,
    "changedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SellerOrderItemStatusChangeLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReturnStatusChangeLog" (
    "id" TEXT NOT NULL,
    "returnId" TEXT NOT NULL,
    "previousStatus" "RefundStatusType" NOT NULL,
    "newStatus" "RefundStatusType" NOT NULL,
    "changedBy" TEXT NOT NULL,
    "changedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReturnStatusChangeLog_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "CustomerOrder" ADD CONSTRAINT "CustomerOrder_deliveryId_fkey" FOREIGN KEY ("deliveryId") REFERENCES "Delivery"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SellerOrder" ADD CONSTRAINT "SellerOrder_customerOrderId_fkey" FOREIGN KEY ("customerOrderId") REFERENCES "CustomerOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SellerOrderItem" ADD CONSTRAINT "SellerOrderItem_sellerOrderId_fkey" FOREIGN KEY ("sellerOrderId") REFERENCES "SellerOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Return" ADD CONSTRAINT "Return_sellerOrderItemId_fkey" FOREIGN KEY ("sellerOrderItemId") REFERENCES "SellerOrderItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Return" ADD CONSTRAINT "Return_deliveryId_fkey" FOREIGN KEY ("deliveryId") REFERENCES "Delivery"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SellerOrderStatusChangeLog" ADD CONSTRAINT "SellerOrderStatusChangeLog_sellerOrderId_fkey" FOREIGN KEY ("sellerOrderId") REFERENCES "SellerOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SellerOrderItemStatusChangeLog" ADD CONSTRAINT "SellerOrderItemStatusChangeLog_sellerOrderItemId_fkey" FOREIGN KEY ("sellerOrderItemId") REFERENCES "SellerOrderItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnStatusChangeLog" ADD CONSTRAINT "ReturnStatusChangeLog_returnId_fkey" FOREIGN KEY ("returnId") REFERENCES "Return"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
