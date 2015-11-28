#import "UICollectionedTableViewCell.h"

@implementation UICollectionedTableViewCell

- (UICollectionedTableViewCell *)init
{
    self = [super init];
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.train wagonDensities] count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UIImage *)portionPaintForDensity:(NSNumber *)density
                            onImage:(UIImage *)image
{
    // 1. Get pixels of image
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(inputCGImage);
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(inputCGImage);
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
    
    for (NSUInteger j = height * (1-[density floatValue]); j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            if (A(pixels[width*j+i]) != 0) {
                pixels[width*j+i] = RGBAMake(255, 0, 0, A(pixels[width*j+i]));
            }
        }
    }
    
    CGContextRef ctx = CGBitmapContextCreate(pixels,
                                             CGImageGetWidth(inputCGImage),
                                             CGImageGetHeight(inputCGImage),
                                             8,
                                             CGImageGetBytesPerRow(inputCGImage),
                                             CGImageGetColorSpace(inputCGImage),
                                             kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(ctx);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    
    free(pixels);
    
#undef R
#undef G
#undef B
#undef A
#undef RGBAMake
    return processedImage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    unsigned long index = [self.train.wagonDensities count] - indexPath.row - 1;
    unsigned long index = indexPath.row;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trainImageCollectionCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UIImage *wagon = nil;
    
    if (index == 0) {
        wagon = [UIImage imageNamed:@"avant-small.png"];
    } else {
        wagon = [UIImage imageNamed:@"wagon-small.png"];
    }
    
    [imageView setImage:[self portionPaintForDensity:[self.train.wagonDensities objectAtIndex:index] onImage:wagon]];
    
    // Trains heading right
    [collectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
    
    return cell;
}

@end

